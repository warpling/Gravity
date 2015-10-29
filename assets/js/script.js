$(document).ready( function () {



// Source: http://stackoverflow.com/questions/11978995/how-to-change-color-of-svg-image-using-css-jquery-svg-image-replacement/
jQuery('img.svg').each(function(){
    var $img = jQuery(this);
    var imgID = $img.attr('id');
    var imgClass = $img.attr('class');
    var imgURL = $img.attr('src');

    jQuery.get(imgURL, function(data) {
        // Get the SVG tag, ignore the rest
        var $svg = jQuery(data).find('svg');

        // Add replaced image's ID to the new SVG
        if(typeof imgID !== 'undefined') {
            $svg = $svg.attr('id', imgID);
        }
        // Add replaced image's classes to the new SVG
        if(typeof imgClass !== 'undefined') {
            $svg = $svg.attr('class', imgClass+' replaced-svg');
        }

        // Remove any invalid XML tags as per http://validator.w3.org
        $svg = $svg.removeAttr('xmlns:a');

        // Replace image with new SVG
        $img.replaceWith($svg);

        // Manually check if the replaced item needs to be animated
        window.setTimeout(function() {
            if ($svg.hasClass('animated')) {
                $svg.addClass('animate');
            }
        }, 1);

    }, 'xml');
});

// Animate in the title stuff
window.setTimeout(function applyAnimations() {
    $('.animated').each(function(){
        // Weird hack so we can addClass to svgs
        $(this).attr('class', function(index, classNames) {
            return classNames + ' animate';
        });
    });
}, 500);

// Scale in and flip up the input field
window.setTimeout(function applyAnimations() {
    $('.animated-with-delay-1').each(function(){
        // Weird hack so we can addClass to svgs
        $(this).attr('class', function(index, classNames) {
            return classNames + ' animate';
        });
    }).promise().done(function() {
        window.setTimeout(function() {
            $('#mce-EMAIL').first().focus();
            $('.input--foldie').first().addClass('input--filled'); // redundancy
            }, 500);
    });
}, 4200);

// Fade in the footer
var footerFadeInDelay = 4200;
var footerAnimationDuration = 1500;
window.setTimeout(function applyAnimations() {
    $('.footer').each(function(){
        $(this).addClass('color-in');
    });
}, footerFadeInDelay);
window.setTimeout(function applyAnimations() {
    $('.footer').each(function(){
        $(this).removeClass('transition');
    });
}, footerFadeInDelay + footerAnimationDuration);



    // I only have one form on the page but you can be more specific if need be.
    var $form = $('#mc-embedded-subscribe-form');

    if ($form.length > 0) {
        $form.submit(function (event) {
            if (event) {
                event.preventDefault();
            }

            if (validate_email($form)) {
                register($form);
            }
            else {
                // TODO: shake email field
                shake();
            }
        });
    }
});

function validate_email($form) {
    var emailAddress = $form.find('#mce-EMAIL')[0].value;
    return /(.+)@(.+){2,}\.(.+){2,}/.test(emailAddress);
}

function register($form) {
    $.ajax({
        type: $form.attr('method'),
        url: $form.attr('action'),
        data: $form.serialize(),
        cache       : false,
        dataType    : 'jsonp',
        jsonp       : 'c',
        contentType: "application/json; charset=utf-8",
        error       : function(err) { alert("Could not connect to the registration server. Please try again later."); },
        success     : function(data) {
            if (data.result != "success") {
                console.log("MailChimp failed to save email: " + data.msg);
                shake();
            } else {
                // It worked, carry on...
                console.log("Email saved successfully.");
                slideOff();
            }
        }
    });
}

var removeShakeTimeout;

function shake() {
    // If there's a timeout to remove the current shake remove it and immediately remove the classes
    if (!!removeShakeTimeout) {
        clearTimeout(removeShakeTimeout);
        $('.input__field--foldie').first().removeClass('shake');
        $('.circle-arrow-button').first().removeClass('shake');
    }

    // Add the shake
    $('.input__field--foldie').first().addClass('shake');
    $('.circle-arrow-button').first().addClass('shake');

    // Remove the classes when the animation finishes in 400ms
    removeShakeTimeout = window.setTimeout(function(){
        $('.input__field--foldie').first().removeClass('shake');
        $('.circle-arrow-button').first().removeClass('shake');
    }, 400);
}

function slideOff() {
    $('#mce-EMAIL').first().addClass('slide-email-off');
    window.setTimeout(function(ev) {
        var emailInput = $('#mce-EMAIL').first();
        // Clear input
        emailInput[0].value = '';
        emailInput.removeClass('slide-email-off');
        emailInput.blur();
        $('.input--foldie').first().removeClass('input--filled'); // redundancy

        $('p.input__label.input__label--foldie').each(function(){
            $(this).text("CONFIRMATION SENT");
        });
    }, 1000); // length of slide animation
}

