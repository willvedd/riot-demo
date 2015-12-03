<art-listing id="listing">
	
	<div if="{results.length > 1}" id="listing-ui">
		<div class="listing-ui-sort">
			<span>View By:</span>
			<button onclick="{titleSortSet}" class="{active: titleSort}">Artwork Title</button>
			<button onclick="{artistSortSet}" class="{active: !titleSort}">Artist Name</button>
		</div>
		<div class="letter-button-contain">
			<span class="jump-to">Jump to:</span>
			<letter-button each="{letter in letters}" letter="{letter}"></letter-button>	
		</div>
		<hr>
	</div>

	<ul if="{titleSort}" id="listing-list">
		<li class="listing-item" each="{result in results}" letter-first="{letterLogic(result)}"><a href="{result.url}"><span class="listing-item-title"><raw content="{result.title}"></raw><span class="listing-item-title-year" if="{result.year}"> ({result.year})</span></span>by {artistDisplay(result.artist)}</li></a>
	</ul>
	<ul if="{!titleSort}" id="listing-list">
		<li class="listing-item" each="{result in results}" letter-first="{letterLogic(result)}">
			<a href="{result.url}"><span class="listing-item-title listing-item-title-artist">{artistDisplay(result.artist_formatted)}</span> – <span class="italic"><raw content="{result.title}"></raw></span><span if="{result.year}"> ({result.year})</span></a></li>
	</ul>
	<div if="{results.length == 0}" class="resetFilters">
		<h1>No results match your filter criteria. <a href="#" role="button" onclick="{resetFilters}">Reset your filtering options</a>.</h1>
	</div>

	<script>
		var self = this;
		self.letters = [];
		self.titleSort = true;

		self.letterLogic = function(result){
			if(self.titleSort) return result.title[0];
			else return result.sort_name[0];
		}

		self.artistDisplay = function(artists){
			var artist_display = '';
			_.each(artists, function(artistVal,i){
				if(i != (artists.length-1)){
					if(self.titleSort){
						artist_display += artistVal + ", ";
					}else{
						artist_display += artistVal + " & ";
					}
				}
				else{
					artist_display += artistVal;
				}
			});
			return artist_display;
		}

		self.titleSortSet = function(){
			self.titleSort = true;
			self.update();
		}
		self.artistSortSet = function(){
			self.titleSort = false;
			self.update();
		}

		self.on('update',function(){
			self.listingController();
		})

		self.resetFilters = function(){RiotControl.trigger('reset_filters_ui')};

		RiotControl.on('state_changed',function(stateObj){
			self.results = stateObj.results;
			if(self.results.length == 0){RiotControl.trigger('no_results')}
			else{
				self.listingController();
			}
			self.update();
		});

		self.listingController = function(){
			self.letters = [];
			if(self.titleSort){
				if(self.results != undefined){
					self.results.sort(function(a,b){
				      if(a.title > b.title) return 1;
				      else return -1;
				    });
					_.each(self.results,function(result){
						if(self.letters.indexOf(result.title[0]) === -1 ){
							self.letters.push(result.title[0]);
						}
					});
				}
			}
			else{
				self.results.sort(function(a,b){
					if(a.sort_name > b.sort_name) return 1;
					else return -1;
			    });
				_.each(self.results,function(result){
					if(self.letters.indexOf(result.sort_name[0]) === -1 ){
						self.letters.push(result.sort_name[0]);
					}
				});					
			}
		}

	</script>
</art-listing>