var PAYMILL_PUBLIC_KEY = "172917682352a3e6970e2aeb385051c1";

    // Enable pusher logging - don't include this in production
    Pusher.log = function(message) {
      if (window.console && window.console.log) window.console.log(message);
    };

    // Flash fallback logging - don't include this in production
    WEB_SOCKET_DEBUG = true;

    var pusher = new Pusher('52e8b9204ddcb6462bfc');
    var channel = pusher.subscribe('payments');
    channel.bind('new_payment', function(data) {
      alert(data);
      console.log(data)
    });

$(document).ready(function(){
  $(".btn").click(function(){
    paymill.createToken({
      number:         $('#cardnumber').val(),
      exp_month:      $('#exp_month').val(),
      exp_year:       $('#exp_year').val(),
      cvc:            $('#secure').val(),
      amount_int:     "10000",
      currency:       "EUR",
      cardholder:     $('#namecard').val()
    },paymillResponseHandler);
  });
})

function paymillResponseHandler(error, result) {
 if (error) {
   // Displays the error above the form
   console.log(error);
   $(".payment-errors").text(error.apierror);
 } else {
  $.ajax({
    type: "POST",
    url: "http://localhost:3000/pay",
    data: { token: result.token, amount: $("#amount").val()},
    success: function(data){
      alert (data)
    }
  });
 }
}
