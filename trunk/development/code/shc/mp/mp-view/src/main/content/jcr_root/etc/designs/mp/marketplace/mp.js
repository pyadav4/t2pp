var interval;
var newsinterval;
var homeTimer=lockInterval=controlshidden=noloop=0;
var noloopShowcase=0;
var shuffleImg=1;
var carouselStart="";
var stopTicker=false;
var scrolling=false;
var pageLoadTimerDelay=5000;
var inactivityTimerDelay=5000;
var transitionInterval=3000;
var slideTimer=100;
var accordionTimer=500;
var fadeDuration=600;
var menuTimeout=500;
var tickerScrollSpeed=7000;
var popTitle;
var popDesc;
$(".language").live("click",function(J){J.preventDefault();
$("#language-chooser").slideToggle(fadeDuration,function(){$("#language-chooser").toggleClass("hidden");
$(".language").toggleClass("selected")
})
});
$("#language-chooser .close-button").live("click",function(J){J.preventDefault();
closeLanguageMenu(1,true)
});


function closeLanguageMenu(){$("#language-chooser").slideUp(fadeDuration);
$(".language").removeClass("selected")
}