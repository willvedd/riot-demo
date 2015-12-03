<app>	
	<ui></ui>
	<div id="app-view-container" onclick="{closeUI}">
		<div class="mww-messaging" if="{mww}">
			<p class="serif italic">Museum Without Walls is an interpretive program for Philadelphia’s public art. Each audio program is told by a variety of people from all walks of life who are directly connected to the sculpture. Hear over 150 voices at sculptures throughout Fairmount Park and Center City.</p>
		</div>
		<map show="{ mapIsActive }" id="map"></map>
		<gallery show="{ galleryIsActive }" id="gallery"></gallery>
		<art-listing show="{ listingIsActive }"></art-listing>
	</div>
	<script>
		var self = this;

		self.on('mount',function(){
			RiotControl.trigger('state_init');
		});

		RiotControl.on('state_changed',function(stateObj){
			self.mapIsActive = false;
			self.galleryIsActive = false;
			self.listingIsActive = false;
			self.mww = false;

			if(stateObj.state.mww){
				self.mww = true;
			}

			if(stateObj.state.mode == 'gallery'){
				self.galleryIsActive = true;
			}
			else if(stateObj.state.mode == 'list'){
				self.listingIsActive = true;
			}
			else{
				self.mapIsActive = true;
				google.maps.event.trigger(map, 'resize'); //this resize event needs to be triggered otherwise map doesn't render properly after being hidden
			}
			if(stateObj.state.mww) var mwwString = '?mww';
			else var mwwString = '';

			riot.route(stateObj.state.mode + "/" + stateObj.state.theme_slug + "/" + stateObj.state.search.replace(/\s+/g, '-') + mwwString);
			self.update();
		});
		riot.tag('raw', '<span></span>', function (opts) {
		    this.updateContent = function () {
		        this.root.innerHTML = opts.content;
		    };
		    this.on('update', function() {
		        this.updateContent();
		    });
		    this.updateContent();
		});
	</script>
</app>

