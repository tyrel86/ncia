window.setInterval(function() {
	var last_on = $("#member-laston").data('value')
	var total = $("#member-count").data('value')

	var next_on_index = next_on();
	var next_off_index = next_off();
	$("#member-laston").data('value', next_on_index);

	$('[data-index=' + next_on_index + ']').toggleClass("hidden")
	$('[data-index=' + next_off_index + ']').toggleClass("hidden");

	function next_off() {
		if( last_on - 4 == 0 ) {
			return 7;
		}
		if( last_on - 4 > 0 ) {
			return last_on - 4;
		} else {
			return 7 - Math.abs((last_on - 4));
		}
	}

	function next_on() {
		if( last_on + 1 <= total ) {
			return last_on + 1;
		} else {
			return 1;
		}
	}

}, 7000);
