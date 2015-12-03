<letter-button>
	<button onclick="{letterJump}">{this.opts.letter}</button>
	
	<script>
		var self = this;
		self.letterJump = function(){
			var jumpTo = jQuery('li[letter-first="' + this.opts.letter +'"]')[0];
			//window.scrollTo(0,)
			//jQuery(window)., {easing: 'easeInOutCirc'});


			jQuery('html, body').animate({
		        scrollTop: jQuery(jumpTo).offset().top - 15,
		    }, 500);
		}

	</script>
</letter-button>