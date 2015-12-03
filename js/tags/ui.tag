<ui id="ui">
	<div class="ui-left">
		<ui-button mode="map" label="Map"></ui-button>
		<ui-button mode="gallery" label="Gallery"></ui-button>
		<ui-button mode="list" label="List"></ui-button>
	</div>
	<button id="ui-toggle" onclick="{openUI}"><span class="screen-reader-text">Toggle Filter Settings Panel</span></button>
	<div id="ui-right">
		<div class="ui-search ui-inline">
			<input size="38"  type="text" name="searchUI" placeholder="Search by Title, Artist or Location" value='{searchVal}' onchange="{searchSet}" onkeyup="{searchSet}">
			<span if="{!searchUI.value.length >0}" class="search-icon"></span>
			<span if="{searchUI.value.length >0}" class="search-icon search-icon-kill" onclick="{searchKill}"></span>
		</div>
		<div class="ui-dropdown ui-inline">
			<select  onchange="{themeSet}" name="themeUI">
				<option value="0" data-slug="all" selected="{selected: 0 == themeVal}">All Themes</option>
				<option each="{themes}" value="{this.id}" data-slug="{this.slug}" selected="{selected: this.id == themeVal}">{this.name}</option>
			</select>
			<span class="dropdown-icon"></span>
		</div>
	 	<div class="ui-inline ui-radios">
	 		<div class="ui-radio">
	 			<input class="ui-inline" type="checkbox" name="apaUI" value="apa" onchange='{apaSet}'><label for="apaUI">aPA Initiated Artworks</label>
	 		</div>	
	 		<div class="ui-radio">
	 			<input class="ui-inline" type="checkbox" name="mwwUI" checked="{mwwVal}" value="mww" onchange='{mwwSet}'><label for="mwwUI">Museum Without Walls</label>
	 		</div>
 		</div>
	</div>
	
	<script>
		var self = this,searchDelay,searchVal;
		self.themes = window.themes;
		self.no_results = false;

		self.mwwSet = function(){
			RiotControl.trigger('mwwSet', this.mwwUI.checked);
		}
		self.apaSet = function(){
			RiotControl.trigger('apaSet', this.apaUI.checked);
		}

		self.themeSet = function(){
			RiotControl.trigger('themeSet', {
				id: this.themeUI.value, 
				slug: self.slugLookup(this.themeUI.value),
			});
		}

		self.searchSet = function() {
			clearTimeout(searchDelay);
		    searchDelay = setTimeout(function(){
		    	RiotControl.trigger('searchSet', self.searchUI.value);
		    },350);
		}
		self.searchKill = function() {
			RiotControl.trigger('searchSet', '');
		}

		RiotControl.on('no_results',function(){
			self.no_results = true;
		})

		RiotControl.on('reset_filters_ui',function(){
			self.mwwUI.checked = false;
			self.apaUI.checked = false;
			self.themeUI.value  = '0';
			self.searchUI.value = '';
			self.theme_slug = 'all';
			RiotControl.trigger('reset_filters_search',{
				search : self.searchUI.value,
				theme: self.themeUI.value,
				theme_slug: self.theme_slug,
				mww: self.mwwUI.checked,
				apa_init: self.apaUI.checked,
			});
		})

		RiotControl.on('state_changed',function(stateObj){
			self.searchVal = stateObj.state.search;
			self.themeVal = stateObj.state.theme;
			self.mwwVal = stateObj.state.mww;
			self.update();
		});

		self.openUI = function(){
			document.getElementById('ui').classList.toggle('ui-right-open');
		}
		self.slugLookup = function(id){
			var slug = 'all';
			_.each(window.themes,function(theme){
				if(theme.id == id) slug = theme.slug;
			})
			return slug;
		}

	</script>
	<style scoped>
		:scoped{
			display:block;
		}
	</style>
</ui>