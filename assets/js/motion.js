
Math.radians = function(degrees) {
  return degrees * Math.PI / 180;
};
 
// Converts from radians to degrees.
Math.degrees = function(radians) {
  return radians * 180 / Math.PI;
};

// Thank You Paul Irish (http://www.paulirish.com/2011/requestanimationframe-for-smart-animating/)
(function() {
    var lastTime = 0;
    var vendors = ['webkit', 'moz'];
    for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
        window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
        window.cancelAnimationFrame =
          window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
    }

    if (!window.requestAnimationFrame)
        window.requestAnimationFrame = function(callback, element) {
            var currTime = new Date().getTime();
            var timeToCall = Math.max(0, 16 - (currTime - lastTime));
            var id = window.setTimeout(function() { callback(currTime + timeToCall); },
              timeToCall);
            lastTime = currTime + timeToCall;
            return id;
        };

    if (!window.cancelAnimationFrame)
        window.cancelAnimationFrame = function(id) {
            clearTimeout(id);
        };
}());

clippedElementID = "clipped"

// angle averaging
maxDeviceAngles = 10;
deviceAngles = [];
deviceAngle = 56;//131; // starting angle
// refreshClipPath(deviceAngle);

deviceMotionStarted = false;
function setupAnimationLoop(){
    console.log("animLoop");
    refreshClipPath(deviceAngle);
    requestAnimationFrame(setupAnimationLoop);
};

function refreshClipPath(angle) {
    var element = document.getElementById(clippedElementID);
    var polygon = calculateClipPath(0, 0, angle);
    // console.log(polygon);
    element.style.webkitClipPath = polygon;
    element.style.clipPath = polygon;
}

// NOTE: Currently centerX/Y are unused
function calculateClipPath(centerX, centerY, angle) {

   var width = window.innerWidth
   || document.documentElement.clientWidth
   || document.body.clientWidth;

   var height = window.innerHeight
   || document.documentElement.clientHeight
   || document.body.clientHeight;

    centerX = width  / 2.0;
    centerY = height / 2.0;

    // used to move the origin to the center
    originOffsetX = width / 2.0;
    originOffsetY = height / 2.0;

    angle %= 360;

    var flipped;
    if (angle >= 180) {
        flipped = true;
        angle %= 180;
    }

    // Exactly 180 is asymptotic
    if (angle >= 179.99999) {
        angle = 179.99999;
    }

    var slope = Math.tan(Math.radians(angle));

    // x = (y - b)/m
    var topXIntercept    = (originOffsetY) / slope;
    var bottomXIntercept = -(height - originOffsetY) / slope;

    var maxPx = 30000;
    topXIntercept   = Math.min(Math.max(topXIntercept, -maxPx), maxPx);
    bottomXIntercept = Math.min(Math.max(bottomXIntercept, -maxPx), maxPx);

    var topXPercent    = 100*(topXIntercept + originOffsetX) / width;
    var bottomXPercent = 100*(bottomXIntercept + originOffsetX) / width;

    var polygon;
    if (flipped) {
        // Left-side based polygon
        polygon = "polygon(" + 0 + "% 0, " + topXPercent + "% 0, " + bottomXPercent + "% 100%, " + 0 + " 100%)";
    }
    else {
        // Right-side based polygon
        polygon = "polygon(" + 100 + "% 0, " + topXPercent + "% 0, " + bottomXPercent + "% 100%, " +  100 + "% 100%)";
    }

    // console.log(polygon);
    return polygon;
}

window.onresize = function(event) {
    refreshClipPath(deviceAngle);
};

if (window.DeviceOrientationEvent) {
    window.addEventListener("devicemotion", handleMotion, true);
}

function handleMotion(event) {
    var acceleration = event.accelerationIncludingGravity;

    // Desktop chrome is reporting it can handle motion, but it returns null acelleration,
    // so we need to check if the device actuall supports motion in this circuitous way.
    if (acceleration.x != null) {

        if (!deviceMotionStarted) {
            deviceMotionStarted = true;
            setupAnimationLoop();
        }

        var gravityAngle = (Math.atan2(acceleration.x, acceleration.y) % (2*Math.PI)) + Math.PI;
        var gravityAngleMagnitude = -1.0 * acceleration.z;

        // rads -> degs
        gravityAngle = Math.degrees(gravityAngle);
        gravityAngle = 360 - gravityAngle;

        recordNewDeviceAngle(gravityAngle);
    }
    // if we're not going to use device motion, add our CSS level animation
    else {
        var element = document.getElementById(clippedElementID);
        element.className = element.className + " animated";
        // A tad later, start the animation
        window.setTimeout(function() {
            element.className = element.className + " animate";
        }, 1);
    }
}

function recordNewDeviceAngle(angle) {

    angle %= 360;

    deviceAngles.push(angle);
    if (deviceAngles.length > maxDeviceAngles) {
        deviceAngles.shift();
    }

    var sumAngle = 0;
    var sumX = 0;
    var sumY = 0;
    for (var ctr = 0; ctr < deviceAngles.length; ctr++) {
        sumAngle += deviceAngles[ctr];
        sumX += Math.cos(Math.radians(deviceAngles[ctr]));
        sumY += Math.sin(Math.radians(deviceAngles[ctr]));
    }

    sumX /= deviceAngles.length;
    sumY /= deviceAngles.length;
    angle = (Math.degrees(Math.atan2(sumY, sumX)) + 360) % 360;

    deviceAngle = angle;
}
