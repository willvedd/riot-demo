<ui-button>
	<button name="{opts.mode}-mode-button" onclick="{modeSet}" mode="{opts.mode}" class="{opts.mode} {active : active == opts.mode}">{opts.label}</button>
	
	<script>
		var self = this;

		self.modeSet = function(e) {
			RiotControl.trigger('modeSet', this.opts.mode);
		}

		RiotControl.on('state_changed',function(stateObj){
			self.active = stateObj.state.mode;
			self.update();
		});
	</script>

</ui-button>