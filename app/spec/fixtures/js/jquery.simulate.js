!function(e,t){"use strict";function n(e){return u.test(Object.prototype.toString.call(e))}function o(e){for(var t=0;t<window.frames.length;t+=1)if(window.frames[t]&&window.frames[t].document===e)return window.frames[t];return window}function r(t){var o,r,i=e(t);return n(i[0])?(r=i,o={left:0,top:0}):(r=e(i[0].ownerDocument||document),o=i.offset()),{x:o.left+i.outerWidth()/2-r.scrollLeft(),y:o.top+i.outerHeight()/2-r.scrollTop()}}function i(t){var o,r,i=e(t);return n(i[0])?(r=i,o={left:0,top:0}):(r=e(i[0].ownerDocument||document),o=i.offset()),{x:o.left-document.scrollLeft(),y:o.top-document.scrollTop()}}var c=/^key/,a=/^(?:mouse|contextmenu)|click/,u=/\[object (?:HTML)?Document\]/;e.fn.simulate=function(t,n){return this.each(function(){new e.simulate(this,t,n)})},e.simulate=function(t,n,o){var r=e.camelCase("simulate-"+n);this.target=t,this.options=o||{},this[r]?this[r]():this.simulateEvent(t,n,this.options)},e.extend(e.simulate,{keyCode:{BACKSPACE:8,COMMA:188,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,LEFT:37,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,NUMPAD_SUBTRACT:109,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SPACE:32,TAB:9,UP:38},buttonCode:{LEFT:0,MIDDLE:1,RIGHT:2}}),e.extend(e.simulate.prototype,{simulateEvent:function(e,t,n){var o=this.createEvent(t,n);this.dispatchEvent(e,t,o,n)},createEvent:function(e,t){return c.test(e)?this.keyEvent(e,t):a.test(e)?this.mouseEvent(e,t):void 0},mouseEvent:function(r,i){var c,a,u,s,l=n(this.target)?this.target:this.target.ownerDocument||document;return i=e.extend({bubbles:!0,cancelable:"mousemove"!==r,view:o(l),detail:0,screenX:0,screenY:0,clientX:1,clientY:1,ctrlKey:!1,altKey:!1,shiftKey:!1,metaKey:!1,button:0,relatedTarget:t},i),l.createEvent?(c=l.createEvent("MouseEvents"),c.initMouseEvent(r,i.bubbles,i.cancelable,i.view,i.detail,i.screenX,i.screenY,i.clientX,i.clientY,i.ctrlKey,i.altKey,i.shiftKey,i.metaKey,i.button,i.relatedTarget||l.body.parentNode),0===c.pageX&&0===c.pageY&&Object.defineProperty&&(a=n(c.relatedTarget)?c.relatedTarget:c.relatedTarget.ownerDocument||document,u=a.documentElement,s=a.body,Object.defineProperty(c,"pageX",{get:function(){return i.clientX+(u&&u.scrollLeft||s&&s.scrollLeft||0)-(u&&u.clientLeft||s&&s.clientLeft||0)}}),Object.defineProperty(c,"pageY",{get:function(){return i.clientY+(u&&u.scrollTop||s&&s.scrollTop||0)-(u&&u.clientTop||s&&s.clientTop||0)}}))):l.createEventObject&&(c=l.createEventObject(),e.extend(c,i),c.button={0:1,1:4,2:2}[c.button]||c.button),c},keyEvent:function(r,i){var c,a;if(i=e.extend({bubbles:!0,cancelable:!0,view:o(a),ctrlKey:!1,altKey:!1,shiftKey:!1,metaKey:!1,keyCode:0,charCode:t},i),a=n(this.target)?this.target:this.target.ownerDocument||document,a.createEvent)try{c=a.createEvent("KeyEvents"),c.initKeyEvent(r,i.bubbles,i.cancelable,i.view,i.ctrlKey,i.altKey,i.shiftKey,i.metaKey,i.keyCode,i.charCode)}catch(u){c=a.createEvent("Events"),c.initEvent(r,i.bubbles,i.cancelable),e.extend(c,{view:i.view,ctrlKey:i.ctrlKey,altKey:i.altKey,shiftKey:i.shiftKey,metaKey:i.metaKey,keyCode:i.keyCode,charCode:i.charCode})}else a.createEventObject&&(c=a.createEventObject(),e.extend(c,i));return(/msie [\w.]+/.exec(navigator.userAgent.toLowerCase())||"[object Opera]"==={}.toString.call(window.opera))&&(c.keyCode=i.charCode>0?i.charCode:i.keyCode,c.charCode=t),c},dispatchEvent:function(t,n,o,r){r.jQueryTrigger===!0?e(t).trigger(e.extend({},o,r,{type:n})):t.dispatchEvent?t.dispatchEvent(o):t.fireEvent&&t.fireEvent("on"+n,o)},simulateFocus:function(){function t(){o=!0}var n,o=!1,r=e(this.target);r.bind("focus",t),r[0].focus(),o||(n=e.Event("focusin"),n.preventDefault(),r.trigger(n),r.triggerHandler("focus")),r.unbind("focus",t)},simulateBlur:function(){function t(){o=!0}var n,o=!1,r=e(this.target);r.bind("blur",t),r[0].blur(),setTimeout(function(){r[0].ownerDocument.activeElement===r[0]&&r[0].ownerDocument.body.focus(),o||(n=e.Event("focusout"),n.preventDefault(),r.trigger(n),r.triggerHandler("blur")),r.unbind("blur",t)},1)}}),e.extend(e.simulate.prototype,{simulateDrag:function(){var n=0,o=this.target,c=this.options,a="corner"===c.handle?i(o):r(o),u=Math.floor(a.x),s=Math.floor(a.y),l={clientX:u,clientY:s},d=c.dx||(c.x!==t?c.x-u:0),f=c.dy||(c.y!==t?c.y-s:0),m=c.moves||3;for(this.simulateEvent(o,"mousedown",l);m>n;n++)u+=d/m,s+=f/m,l={clientX:Math.round(u),clientY:Math.round(s)},this.simulateEvent(o.ownerDocument,"mousemove",l);e.contains(document,o)?(this.simulateEvent(o,"mouseup",l),this.simulateEvent(o,"click",l)):this.simulateEvent(document,"mouseup",l)}})}(jQuery);
