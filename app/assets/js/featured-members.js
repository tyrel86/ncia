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
		$(this).html() == "Show All" ? $(this).html("Hide") : $(this).html("Show All") 
	})

	$('.close').click( function() {
		$(this).parent().fadeOut("slow")
	})
})

/* Custom stuff */
/* populate account type select price note this is doen again on the backend for security reasons*/
$(document).ready( function() {
	$("#prepay-submit").submit(function (e) {
			if( $("#terms-check").attr('checked') != "checked" ) {
					e.preventDefault();
					alert("Please read and agree to to our code of conduct. Thank you.")
			}	
	})

	function change_recuring( value ) {
		$("#recr").attr('value',value)	
	}

	$('#member_type').change( function() {
		selected = $('#member_type').find(":selected")
		$("#desc").attr('value', selected.html())

		switch(selected.html()) {
			case "Sustaining Monthly Membership - $500":
				change_recuring( 3 )
				break;
			case "Sponsoring Monthly Membership - $250":
				change_recuring( 2 )
				break;
			case "Regular Monthly Membership - $100":
				change_recuring( 1 )
				break;
			default:
				change_recuring( "Null" )
		}
	})

})
