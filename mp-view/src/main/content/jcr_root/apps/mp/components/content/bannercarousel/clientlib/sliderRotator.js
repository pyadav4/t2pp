$(document).ready( function() {

    //initialize home-hero rotation
    if ($('#slider .slider-item').length > 0) {
              
        initPromoRotate();
            
        //Init auto-rotating hero
        $('#slider #slider-btns a:first').trigger('click');
         
    
    
        $('#trayarrows-glance, #trayarrows-headlines').hide();

        //Init hero button opacity animation
        $('#slider-btns a.on').animate({
            "opacity" : .250
            }, 4500 );
    }

        if ($('#herowide .herowide-item').length > 0) {
            initPromoRotate();
    
            // init rotation on wideheros
            $('#herowide #herowide-btns a:first').trigger('click');
        }

    });





// FUNCTIONS

/* ===== PROMO ROTATION ================================================================================================ */

function initPromoRotate() {
    
   

    // Set as slider or herowide
    var promoA_parent = '#slider';
    var promoA_items = '#slider .slider-item';
    var promoB_parent = '#herowide';
    var promoB_items = '#herowide .herowide-item';
    
    var promoA_length = $(promoA_items).length;
    var promoB_length = $(promoB_items).length;
    var promoType = '';
    var promoCount = 0;
    var promoOn = 0;
    var autoPromoRotate;
    var promoRotateSpeed=0;
    var promoFadeSpeed = 1500;
    
    if($('#rotationperiod').length > 0) {
        promoRotateSpeed = ($('#rotationperiod').text()) * 1000;
    }
    else
    {
        promoRotateSpeed = 5000;
    }
    
    if (promoA_length > 0) { 
        promoCount = promoA_length; 
        promoType = 'promoA'; 
        }
    else if (promoB_length > 0) { 
        promoCount = promoB_length; 
        promoType = 'promoB' 
    }
    
    if (promoCount > 1) {       //if more than one promo exists
    
        if (promoType == 'promoA') {
            
            $('#slider .slider-item').each(function(){      //add hero background images
                var rotateImg = $(this).attr("rel");        
                $('#slider-images').append("<div class=\"slide\" style=\"background:url(\'" + rotateImg + "\') top center no-repeat;\"><\/div>"); 
            });   
            $('.slide:first').css('display', 'block');            
            
            $(promoA_parent).append('<div id="slider-btns" class="clearfix"></div>');     //add promo navigation button container
            $('#slider-btns').append('<p class="dot-right"></p>');
            $(promoA_items).each(function (index) {     //iterate thru promos
                $('#slider-btns p').append('<a href="" rel="' + (index) + '"></a>');      //append anchor to promo nav container with unique 'rel' attribute
      
                if (index == 0) {       //add class="on" to first promo nav anchor
                    $('#slider-btns p.dot-right a:first').addClass('on'); 
                } 
            });
        }
        if (promoType == 'promoB') {
            
            $(promoB_parent).append('<div id="herowide-btns" class="clearfix"></div>'); //add promo navigation button container
            $('#herowide-btns').append('<p class="herowide-btns-right"></p>');
            $(promoB_items).each(function (index) { //iterate thru promos
             
                $('#herowide-btns p').append('<a href="" rel="' + (index) + '"></a>'); //append anchor to promo nav container with unique 'rel' attribute
                if (index == 0) { $('#herowide-btns p.herowide-btns-right a:first').addClass('on'); } //add class="on" to first promo nav anchor
            });
         }
    }
    
    
    function rotatePromo() { //start promo rotation timer
        autoPromoRotate = window.setInterval(function () {      //set 10 second rotation interval
            promoOn++;       //increment "promoOn" variable by 1
            
            if (promoOn == promoCount) {        //if we reach the last promo, reset the "promoOn" variable back to beginning
                promoOn = 0;        
            }
            
            if (promoType == 'promoA') {
                $('#slider-btns a:eq(' + promoOn + ')').click();      //trigger click event
                
                
            }   else if (promoType == 'promoB') {
                        $('#herowide-btns a:eq(' + promoOn + ')').click();      //trigger click event
                    }
                }, promoRotateSpeed);
    }
    
    
  function clearPromoInterval() {       //clear promo rotation timer
    if (autoPromoRotate != "undefined") {       //if the promo rotation timer is defined
        window.clearInterval(autoPromoRotate);      //remove the timer
    }
    }
    
    $('#nav-main li').live('click', function(){ clearPromoInterval(); });//clear previously set timer
    $('.mm-content .x-close').live('click', function(){ rotatePromo();  });//start new timer  
    $('#slider-btns a, #herowide-btns a').live('click', function () {     //promo navigation click event listener
        
        clearPromoInterval();       //clear previously set timer
        rotatePromo();      //start new timer
        getRel = $(this).attr('rel');       //get the current "rel" attribute
        promoOn = getRel;       //update the "promoOn" variable
        
        //change hero images
        $('.slide').css('display', 'none');
        $('.slide').eq(promoOn).fadeIn(promoFadeSpeed);
        
        
        
        if (!$(this).hasClass('on')) {      //if clicked element does NOT have a class attribute of "on"
            getRel = parseInt(getRel);      //get the value of the "rel" attribute and convert it to an integer
            $('#slider-btns a.on, #herowide-btns a.on').removeClass('on');        //clear any promo nav items that currently have a class attribute of "on"
            $(this).addClass('on');         //add class attribute of "on" to the clicked element

            if (promoType == 'promoA') {
                $(promoA_items).hide();
                $(promoA_items).removeClass('on');      //hide promos
                $(promoA_items + ':eq(' + getRel + ')').fadeIn(promoFadeSpeed);         //fade in corresponding promo
                $(promoA_items + ':eq(' + getRel + ')').addClass('on');
                var thisBg = $(promoA_items +'.on').attr('rel');
                
                $('#slider-images img').fadeOut(500, function()   {       // Fade out previous hero image
                    $('#slider-images img').attr('src', thisBg).fadeIn(promoFadeSpeed);       // Swap and fade in new hero image
                });
                
                // Animate hero button background as timer  
                $('#slider-btns a').css('opacity', '1');
                $('#slider-btns a.on').animate({
                    "opacity" : .250
                }, promoFadeSpeed );
            }
            
            if (promoType == 'promoB') {
                $(promoB_items).hide();
                $(promoB_items).removeClass('on');      //hide promos
                $(promoB_items + ':eq(' + getRel + ')').fadeIn(promoFadeSpeed);         //fade in corresponding promo
                $(promoB_items + ':eq(' + getRel + ')').addClass('on');
            }
        }
        return false;

    });
        
    // right/left arrow rotation on homepage
    $('#btn-sliderleft').click( function(e) {
        e.preventDefault(); 
		if ( $('#slider-btns a:first').hasClass('on') ) {         // If currently on first slide
            $('#slider-btns a:last').trigger('click');        // Go to last slide in reverse loop
            }   else {
                    $('#slider-btns a.on').prev('a').trigger('click');        // If not first go to previous slide
                }
           
    });            
            
    $('#btn-sliderright').click( function(e) {
        e.preventDefault(); 
		if ($('#slider-btns a:last').hasClass('on')) {
            $('#slider-btns a:first').trigger('click');
            }   else {
                    $('#slider-btns a.on').next('a').trigger('click');
                }
           
    });
   
   
   
   
    $("#slider-images").attr("ontouchstart","touchStart(event,'slider-images');");
    $("#slider-images").attr("ontouchend","touchEnd(event);");
    $("#slider-images").attr("ontouchmove","touchMove(event);");
    $("#slider-images").attr("ontouchcancel","touchCancel(event);");
    
    
}

// TOUCH-EVENTS SINGLE-FINGER SWIPE-SENSING JAVASCRIPT
    
    
    // this script can be used with one or more page elements to perform actions based on them being swiped with a single finger

    var triggerElementID = null; // this variable is used to identity the triggering element
    var fingerCount = 0;
    var startX = 0;
    var startY = 0;
    var curX = 0;
    var curY = 0;    
    var minLength = 72; // the shortest distance the user may swipe
    var swipeLength = 0;
    var swipeAngle = null;
    var swipeDirection = null;
    
    // NOTE: the touchStart handler should also receive the ID of the triggering element
    // make sure its ID is passed in the event call placed in the element declaration, like:
    // <div id="picture-frame" ontouchstart="touchStart(event,'picture-frame');"  ontouchend="touchEnd(event);" ontouchmove="touchMove(event);" ontouchcancel="touchCancel(event);">

    function touchStart(event,passedName) {
        		
		// disable the standard ability to select the touched object
        event.preventDefault();     
        // get the total number of fingers touching the screen
        fingerCount = event.touches.length;
       // since we're looking for a swipe (single finger) and not a gesture (multiple fingers),
        // check that only one finger was used
        if ( fingerCount == 1 ) {        
            // get the coordinates of the touch
            startX = event.touches[0].pageX;
            startY = event.touches[0].pageY;
            // store the triggering element ID
            triggerElementID = passedName;
        } else {
            // more than one finger touched so cancel
            touchCancel(event);
        }
    }
	
    function touchMove(event) {
        // disable the standard ability to select the touched object
            event.preventDefault();
        //Finding out the touch end points while moving finger
           if ( event.touches.length == 1 ) {
            curX = event.touches[0].pageX;
            curY = event.touches[0].pageY;
            } else {
                touchCancel(event);
            }          
    }
    
    function touchEnd(event) {
        
		// disable the standard ability to select the touched object
        event.preventDefault();
        
        // check to see if more than one finger was used and that there is an ending coordinate
        if ( fingerCount == 1 && curX != 0 ) {
            // use the Distance Formula to determine the length of the swipe
            swipeLength = Math.round(Math.sqrt(Math.pow(curX - startX,2) + Math.pow(curY - startY,2)));
            // if the user swiped more than the minimum length, perform the appropriate action
            if ( swipeLength >= minLength ) {
                caluculateAngle();
                determineSwipeDirection();
                processingRoutine();
                touchCancel(event); // reset the variables
            } else {
                touchCancel(event);
            }   
        } else {
            touchCancel(event);
        }    
    }

    function touchCancel(event) {
        // reset the variables back to default values
        fingerCount = 0;
        startX = 0;
        startY = 0;
        curX = 0;
        curY = 0;
        
        swipeLength = 0;
        swipeAngle = null;
        swipeDirection = null;
        triggerElementID = null;
    }
    //Calculating the angle in which the swipe occured, considering it in 360 degree
    function caluculateAngle() {
        var X = startX-curX; // start and end point of swipe diff in x axis
        var Y = curY-startY; // start and end point of swipe diff in y axis
        var Z = Math.round(Math.sqrt(Math.pow(X,2)+Math.pow(Y,2))); //the distance - rounded - in pixels
        var r = Math.atan2(Y,X); //angle in radians (Cartesian system)
        swipeAngle = Math.round(r*180/Math.PI);  // angle in degrees
        if ( swipeAngle < 0 ) { swipeAngle =  360 - Math.abs(swipeAngle); }
    }
    
	//Finding out the swipe direction with the angle
    function determineSwipeDirection() {
        if ( (swipeAngle <= 45) && (swipeAngle >= 0) ) {
            swipeDirection = 'left';
        } else if ( (swipeAngle <= 360) && (swipeAngle >= 315) ) {
            swipeDirection = 'left';
        } else if ( (swipeAngle >= 135) && (swipeAngle <= 225) ) {
            swipeDirection = 'right';
        } else {
            swipeDirection = 'left';
        }
    }
    
    function processingRoutine(event) {
        var swipedElement = document.getElementById(triggerElementID);
        if ( swipeDirection == 'left' ) {
            // Triggering the next slide                   
            if ($('#slider-btns a:last').hasClass('on'))
                {
                    $('#slider-btns a:first').trigger('click');
                }   
            else {
                    $('#slider-btns a.on').next('a').trigger('click');
                 }
            event.preventDefault();
        } else if ( swipeDirection == 'right' ) {
            // Triggering the prev slide      
            if ( $('#slider-btns a:first').hasClass('on') ) {         // If currently on first slide
            $('#slider-btns a:last').trigger('click');        // Go to last slide in reverse loop
            }   else {
                    $('#slider-btns a.on').prev('a').trigger('click');        // If not first go to previous slide
                }
           event.preventDefault();
        } 
		
        
    }