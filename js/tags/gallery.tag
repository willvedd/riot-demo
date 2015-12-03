<gallery class="flex-contain-wrap">
	<article each="{results}" class="flex-1 {billboard big bg-yellow flex-1 inset-border flex-contain featured: featured} {squart : !featured}">
		<div if="{!featured}" class="squart-inner">
			<span if="{mww == '1'}" class="icon-mww"></span>
			<img if="{img}" src="{img.mid}">
			<div class="squart-info">
				<h1 class="title serif-cond"><raw content="{title}"></raw><span if="{year}" class="gallery-artwork-year"> ({year})</span></h1>
				<p class="squart-subtitle"><span each="{artist_val in artist}">{artist_val}<br></span></p>
			</div>
		</div>
		<div if="{featured}" class="flex-1 flex-img">
			<div if="{img}" class="bg-img" style="background-image:url({img.big});"></div>
			<div if="{img}" class="img-inner">
				<img if="{img}" class="b-lazy" src="" alt=">" data-src="{img.big}" />
			</div>
		</div>
		<div if="{featured}" class="board-content col-half flex-2 ">
			<div class="board-inner basic">
				<div class="label board up sans bold text-white">Featured Artwork</div>	
				<h1 class="serif-cond"><raw content="{title}"></raw><span if="{year}" class="artwork-year"> ({year})</span></h1>
				<p class="billboard-medium-artist tracking-25">by <span each="{artist_val in artist}">{artist_val}<br></span></p>
				<raw if="{excerpt}" class="desc" content="{excerpt}"></raw> 
			</div>
		</div>
	</article>
	<div if="{results.length == 0}" class="resetFilters">
		<h1>No results match your filter criteria. <a href="#" role="button" onclick="{resetFilters}">Reset your filtering options</a>.</h1>
	</div>
	

	<script>
	var self = this;

	self.resetFilters = function(){RiotControl.trigger('reset_filters_ui')};

	RiotControl.on('state_changed',function(stateObj){
		self.results = stateObj.results;
		self.update();
	});
	</script>
</gallery>


			