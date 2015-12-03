// TodoStore definition.
// Flux stores house application logic and state that relate to a specific domain.
// In this case, a list of todo items.
function ExploreStore() {
  
  var self = this

  riot.observable(self) // Riot provides our event emitter.
  
  self.state = {//state bundle to keep track of everything in one place
    mode: 'map',
    mww: false,
    apa_init: false,
    search: '',
    theme: '',
    theme_slug: '',
  };

  self.results = [];

  // Our store's event handlers / API.
  // This is where we would use AJAX calls to interface with the server.
  // Any number of views can emit actions/events without knowing the specifics of the back-end.
  // This store can easily be swapped for another, while the view components remain untouched.

  self.on('state_init', function() {
    
    riot.route.parser(function(path) {
      var raw = path.split('?');
      var params = raw[0].split('/');
      var mww = raw[1];
      params.unshift(mww);
      return params;
    })

    riot.route.exec(function(mww, modeParam, themeParam, searchParam) {
      if(modeParam == 'gallery'){
        self.state.mode = 'gallery';
      }
      else if(modeParam == 'list'){
        self.state.mode = 'list';
      }
      else{
        self.state.mode = 'map';
      }

      if(themeParam != '' && themeParam != undefined){
        self.state.theme_slug = themeParam;
        self.state.theme = self.themeIDlookup(themeParam);
      }
      else{
        self.state.theme_slug = 'all';
        self.state.theme = '0';
      }

      if(searchParam != '' && searchParam != undefined){
        self.state.search = searchParam.replace(/-/g, ' ');
      }
      else{
        self.state.search = '';
      }
      if(mww === 'mww'){
        self.state.mww = true;
      }
      else{
        self.state.mww = false;
      };
    });

    filterData();

    self.trigger('map_init',{
      state: self.state
    })

    self.trigger('state_changed', {
      state: self.state, 
      results: self.results
    });
  });

  self.on('mwwSet', function(newMww) {
    self.state.mww = newMww;
    filterData();
    self.trigger('state_changed', {
      state: self.state, 
      results: self.results
    });
  });

  self.on('apaSet', function(newApa) {
    self.state.apa_init = newApa;
    filterData();
    self.trigger('state_changed', {
      state: self.state, 
      results: self.results
    });
  });

  self.on('searchSet', function(newSearch) {
    self.state.search = newSearch;
    filterData();
    self.trigger('state_changed', {
      state: self.state, 
      results: self.results
    });
  });

  self.on('themeSet', function(themeObj) {
    self.state.theme = themeObj.id;
    self.state.theme_slug = themeObj.slug;
    filterData();
    self.trigger('state_changed', {
      state: self.state, 
      results: self.results
    });
  });

  self.on('modeSet', function(newMode) {
    self.state.mode = newMode;
    filterData();
    self.trigger('state_changed', {
      state: self.state, 
      results: self.results
    });
  });

 self.on('reset_filters_search', function(uiState) {
    self.state.theme = uiState.theme;
    self.state.theme_slug = uiState.theme_slug;
    self.state.search = uiState.search;
    self.state.mww = uiState.mww;
    self.state.apa_init = uiState.apa_init;

    filterData();
    self.trigger('state_changed', {
      state: self.state, 
      results: self.results
    });
  });

  function filterData(){
    self.results = window.artworks.filter(function(artNode){
      if(artNode.mww == self.state.mww || self.state.mww == false){
        if(artNode.apa_init == self.state.apa_init || self.state.apa_init == 0){
          if(self.themeSearch(artNode.themes,self.state.theme) || self.state.theme == '0'){
            if(self.state.search == '') return this;
            else if(artNode.title.replace(/-/g, ' ').toLowerCase().indexOf(self.state.search.toLowerCase()) != -1 || artNode.location.replace(/-/g, ' ').toLowerCase().indexOf(self.state.search.toLowerCase()) != -1 || _.find(artNode.artist,function(artist){if(artist.replace(/-/g, ' ').toLowerCase().indexOf(self.state.search.toLowerCase()) != -1){return true;}})){
              return this;
            }
          }
        }
      }
    });
    self.results.sort(function(a,b){
      if(a.title > b.title) return 1;
      else return -1;
    });
  }

  self.themeSearch = function(set,value){
    var found = false;
    _.each(set,function(item){
      if(item == value) found = true;
    })
    return found;
  }

  self.themeIDlookup = function(slug){
    var themeID = 0;
    _.each(window.themes,function(theme){
      if(theme.slug == slug) themeID = theme.id;
    })
    return themeID;
  }

}







