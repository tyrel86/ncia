window.setInterval( function() {
	var total = $("#member-count").data('value')
	var last_on = $('#member-laston').data('value')
	var next_on_index = next_on();
	var next_off_index = next_off();
	$("#member-laston").data('value', next_on_index);

	$('[data-index=' + next_on_index + ']').toggleClass("hidden")
	$('[data-index=' + next_off_index + ']').toggleClass("hidden");

	// alert( "Laston " + last_on + "\ntotal " + total + "\nnext_on " + next_on_index + "\nnext_off " + next_off_index );

	function next_off() {
		var simple_case = last_on - 4
		if( simple_case == 0 ) {
			return total;
		}
		if( simple_case > 0 ) {
			return last_on - 4;
		}
		if( simple_case < 0 ) {
			return total + simple_case;
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

$(document).ready( function() {
	$('.expand-contract').click( function() {
		var lis = $(this).parent().next().children().find('a')
		if( lis.size() > 9 ) {
			var lis_over_nine = lis.slice(9,lis.size())
			lis_over_nine.each( function() {
				$(this).toggleClass( "hidden" )
				$(this).parent().toggleClass( "hidden" )
			})
		}
		$(this).html() == "+" ? $(this).html("-") : $(this).html("+") 
	})

	$('.close').click( function() {
		$(this).parent().fadeOut("slow")
	})
})
