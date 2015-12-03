<map id="mapContainer">
<div  if="{noResults}" class="resetFilters">
	<h1>No results match your filter criteria. <a href="#" role="button" onclick="{resetFilters}">Reset your filtering options</a>.</h1>
</div>
<div id="map"></div>
<div class="map-disclaimer">
	<span class="sans bold">Note: </span><span class="serif italic">This map features a select number of public artworks in Philadelphia that have been initiated by diverse public and private agencies.</span>
</div>
<script>
	var self = this;

 	var map,
 		panToFocal,
 		mapMarkers = [],
 		urlMod = (function(){
			if(window.devicePixelRatio > 1.5) return '2x';
			else return '';
		})(),
		markerScale = (function(){
			if(window.devicePixelRatio > 1.5) return new google.maps.Size(33,42);
			else return new google.maps.Size(33,42);
		})(),
 		markerSize = (function(){
			if(window.devicePixelRatio > 1.5) return new google.maps.Size(66,83);
			else return new google.maps.Size(33,42);
		})(),
		markerAnchor = (function(){
			return new google.maps.Point(12.5, 42);
		})(),
		markerOrigin = (function(){
			return new google.maps.Point(0, 0);
		})();

		regMarker = {
			url: 'images/pin_red'+urlMod+'.png',
			size: markerSize,
			scaledSize: markerScale,
			origin:markerOrigin,
			anchor: markerAnchor,
 		},
		mwwMarker = {
			url: 'images/pin_green'+urlMod+'.png',
			// This marker is 20 pixels wide by 32 pixels tall.
			size: markerSize,
			scaledSize: markerScale,
			origin:markerOrigin,
			anchor: markerAnchor,
 		},
 		regMarkerFaded = {
			url: 'images/pin_red_faded'+urlMod+'.png',
			size: markerSize,
			scaledSize: markerScale,
			origin:markerOrigin,
			anchor: markerAnchor,
 		},
 		mwwMarkerFaded = {
			url: 'images/pin_green_faded'+urlMod+'.png',
			size: markerSize,
			scaledSize: markerScale,
			origin:markerOrigin,
			anchor: markerAnchor,
 		},
		styles = [{"featureType":"administrative","elementType":"labels.text.fill","stylers":[{"color":"#444444"}]},{"featureType":"landscape","elementType":"all","stylers":[{"color":"#f2f2f2"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"on"}]},{"featureType":"poi","elementType":"labels.text","stylers":[{"saturation":"-100"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"lightness":"52"},{"gamma":"1.00"}]},{"featureType":"poi","elementType":"labels.text.stroke","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"labels.icon","stylers":[{"saturation":"-100"}]},{"featureType":"poi.attraction","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"poi.attraction","elementType":"geometry.fill","stylers":[{"visibility":"off"}]},{"featureType":"poi.business","elementType":"geometry.fill","stylers":[{"visibility":"off"}]},{"featureType":"poi.government","elementType":"geometry.fill","stylers":[{"visibility":"off"}]},{"featureType":"poi.medical","elementType":"geometry.fill","stylers":[{"visibility":"off"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#e5e9bb"}]},{"featureType":"poi.park","elementType":"labels.text","stylers":[{"saturation":"-100"}]},{"featureType":"poi.park","elementType":"labels.icon","stylers":[{"saturation":"-100"}]},{"featureType":"poi.place_of_worship","elementType":"geometry.fill","stylers":[{"visibility":"off"}]},{"featureType":"poi.school","elementType":"geometry.fill","stylers":[{"visibility":"off"}]},{"featureType":"poi.school","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},{"featureType":"poi.sports_complex","elementType":"geometry.fill","stylers":[{"visibility":"off"}]},{"featureType":"poi.sports_complex","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"all","stylers":[{"saturation":-100},{"lightness":45}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"gamma":"1.00"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"visibility":"on"}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.fill","stylers":[{"color":"#f8bb1b"}]},{"featureType":"road.arterial","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"all","stylers":[{"color":"#46bcec"},{"visibility":"on"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#62cccb"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#ffffff"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"visibility":"off"}]}],

 		infowindow = new google.maps.InfoWindow({
    		content: '',
    		pixelOffset: (function(){
				if(window.devicePixelRatio > 1.5) return new google.maps.Size(-17, -2);
			})(),
		});

	RiotControl.on('map_init', function(stateObj){
		self.initializeMap();
		self.drawPoints();
	})

	RiotControl.on('state_changed', function(stateObj){
		filterPoints(stateObj.state)
		self.update();
	})

	self.initializeMap = function() {
		var mapProp = {
			center:new google.maps.LatLng(39.961455,-75.148097),
			disableDefaultUI: true, // a way to quickly hide all controls
			mapTypeId:google.maps.MapTypeId.ROADMAP,
			panControl: true,
			styles: styles,
			zoom:12,
			scrollwheel: false,
			zoomControl: (function(){
				if(window.innerWidth >= 768 || !window.artDetailView) return true;
				else return false;
			})(),
			zoomControlOptions: {
	        	position: google.maps.ControlPosition.RIGHT_CENTER,
	    	},
		};

		map = new google.maps.Map(document.getElementById("map"),mapProp);
	}

	function drawPoint(pointData,i){
		var p = pointData,
			marker;

		if(p.mww) marker = mwwMarker;
		else marker = regMarker;
		var point = new google.maps.Marker({
			artist: p.artist,
			apa_init: p.apa_init,
			icon: marker,
			id: p.id,
			img: p.img,
			location: p.location,
			map: map,
			mww: p.mww,
			position: new google.maps.LatLng(p.lat,p.lon),
			region: p.region,
			lat:p.lat,
			lon:p.lon,
			themes: p.themes,
			title: p.title,
			url: p.url,
			year: p.year,
		});

		mapMarkers.push(point);
		
		google.maps.event.addListener(point, 'click', (function (point) {
	        return function () {
        	 	_.each(mapMarkers, function(marker){
	        	 	marker.setMap(null);
	        		if(marker.mww) marker.setIcon(mwwMarkerFaded);
	        		else marker.setIcon(regMarkerFaded);
	        	 	marker.setMap(map);
	        	})
	        	if(point.mww) point.icon = mwwMarker;
	        	else point.icon = regMarker;
	            self.setAndOpenInfoWindow(point);
	            map.panTo(this.getPosition());
	        }
    	})(point));
	}

	self.drawPoints = function(stateObj){
		_.each(window.artworks,function(artItem,i){
			drawPoint({
				artist: artItem.artist,
				apa_init: artItem.apa_init,
				id: artItem.id,
				img: (function() {
					if(artItem.img !== null && artItem.img !== undefined){
						if(artItem.img.hasOwnProperty('mid')) return artItem.img.mid;
						else if(artItem.img.hasOwnProperty('lil')) return artItem.img.lil;
					}
					return false;
				})(),
				lat: artItem.coordinates.lat, 
				lon: artItem.coordinates.lng,
				location: artItem.location,
				mww: artItem.mww,
				region: artItem.region,
				themes: artItem.themes,
				title: artItem.title,
				url: artItem.url,
				year: artItem.year,
			},i);
		})
	}

	function filterPoints(state){
		var minZoom = 17;

		self.lats = [];
		self.lons = [];
		self.markerIndex = 0;

		_.each(mapMarkers,function(marker,i){
			if(marker.mww) marker.setIcon(mwwMarker);//unfade all marker icons
    		else marker.setIcon(regMarker);//unfade all marker icons
			if(marker.mww == state.mww || state.mww != true){
				if(marker.apa_init == state.apa_init || state.apa_init == 0){
					if(self.themeSearch(marker.themes,state.theme) || state.theme == '0'){
						if(state.search =='' || marker.title.toLowerCase().indexOf(state.search.toLowerCase()) != -1 || marker.location.toLowerCase().indexOf(state.search.toLowerCase()) != -1 || _.find(marker.artist,function(artist){if(artist.replace(/-/g, ' ').toLowerCase().indexOf(state.search.toLowerCase()) != -1){return true;}})){
							marker.setVisible(true);
							self.markerIndex = i;
							self.lats.push(marker.lat);
							self.lons.push(marker.lon);
						}
						else{
							marker.setVisible(false);
						}
					}
					else{
						marker.setVisible(false);
					}
				}
				else{
					marker.setVisible(false);
				}
			}
			else{
				marker.setVisible(false);
			}
		})

		if(self.lats.length > 0){
			self.noResults = false;
			var maxLat = Math.max.apply(Math, self.lats);
			var minLat = Math.min.apply(Math, self.lats);
			var maxLon = Math.max.apply(Math, self.lons);
			var minLon = Math.min.apply(Math, self.lons);

			clearTimeout(panToFocal);
		    panToFocal = setTimeout(function(){
		    	infowindow.close();
				if(self.lats.length == 1 ){
			    	map.panTo(new google.maps.LatLng(minLat,minLon))
			    	map.setZoom(minZoom);
			    	self.setAndOpenInfoWindow(mapMarkers[self.markerIndex]);
			    }
			    else if(self.lats.length > 1){
		    		var northEast = new google.maps.LatLng(maxLat , maxLon );
					var southWest = new google.maps.LatLng(minLat ,  minLon );
					var bounds = new google.maps.LatLngBounds((southWest ),(northEast));
					map.panTo(new google.maps.LatLng( (minLat + maxLat)/2 ,(minLon + maxLat)/2  ))
					map.fitBounds(bounds);
					google.maps.event.addListener(map, 'zoom_changed', function() {
				 		if (map.getZoom() > minZoom) map.setZoom(minZoom);
				   	});
			    }
		    }, 300);
		}
		else{//no results
			self.noResults = true;
			infowindow.close();
		}
	}


	self.themeSearch = function(set,value){
	  var found = false;
	  _.each(set,function(item){
	    if(item == value){
	      found = true;
	    }
	  })
	  return found;
	}

	self.setAndOpenInfoWindow = function(p) {//sets content for popup modal then opens it
		if(p.img){//being defensive against broken images
			if(p.mww){
				p.imgMarkup = 
				'<div class="map-popup-img-contain flex-1">'+
					'<a href="'+p.url+'"><span class="icon-mww"></span><img src="' + p.img + '"></a>' +
				'</div>';
			}
			else{
				p.imgMarkup = 
				'<div class="map-popup-img-contain flex-1">'+
					'<a href="'+p.url+'"><img src="' + p.img + '"></a>' +
				'</div>';
			}
		}else{
			p.imgMarkup = '';
		}
		if(p.year != ''){
			p.year_display = ' <span class="popup-year">('+ p.year +')</span>'
		}
		else{
			p.year_display = '';
		}
		p.artist_display = '';
		_.each(p.artist, function(artistVal,i){
			if(i != (p.artist.length-1)){
				p.artist_display += artistVal + "<br>";
			}
			else{
				p.artist_display += artistVal;
			}
		});

		infowindow.setContent(
	    	'<article class="map-popup">'+
	    		p.imgMarkup +
	            '<div class="map-popup-info flex-2">'+
	            	'<div class="map-popup-info-inner">'+
		            	'<h1 class="serif-cond title"><a href="'+ p.url+'">'+ p.title + p.year_display + '</a></h1>' + 
		            	'<p>by ' + p.artist_display + '</p>'+
		            	'<div class="map-popup-location">'+
			            	'<span class="map-popup-location-icon"></span>'+
			            	'<div class="map-popup-location-copy">'+
			            		p.location+
			            	'</div>' +
			            '</div>'+
						'<a href="'+p.url+'" class="btn solid-arrow gray">Learn More</a>' +
					'</div>'+
	            '</div>'+
	    	'</article>');
		infowindow.open(map,p);
	}

	RiotControl.on('state_changed',function(){
		self.update();
	})

	self.resetFilters = function(){RiotControl.trigger('reset_filters_ui')};

</script>
</map>