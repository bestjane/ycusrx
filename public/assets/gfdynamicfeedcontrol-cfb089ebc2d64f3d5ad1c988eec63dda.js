/**
 * Copyright (c) 2008 Google Inc.
 *
 * You are free to copy and use this sample.
 * License can be found here: http://code.google.com/apis/ajaxsearch/faq/#license
*/
/**
 * @fileoverview A feed gadget based on the AJAX Feed API.
 * @author dcollison@google.com (Derek Collison)
 */
/**
 * GFdynamicFeedControl
 * @param {String} feed The feed URL.
 * @param {String|Object} container Either the id string or the element itself.
 * @param {Object} options Options map.
 * @constructor
 */
function GFdynamicFeedControl(e,t,n){this.nodes={},this.collapseElements=[],this.feeds=[],this.results=[];if(typeof e=="string")this.feeds.push({url:e});else if(typeof e=="object")for(var r=0;r<e.length;r++){var i=e[r],s={},o;if(typeof i=="string")s.url=e[r];else if(typeof i=="object"){s=e[r];if(s&&s.title){var u=s.title;s.title=u.replace(/</g,"&lt;").replace(/>/g,"&gt;")}}this.feeds.push(s)}typeof t=="string"&&(t=document.getElementById(t)),this.parseOptions_(n),this.setup_(t)}GFdynamicFeedControl.DEFAULT_NUM_RESULTS=4,GFdynamicFeedControl.DEFAULT_FEED_CYCLE_TIME=18e5,GFdynamicFeedControl.DEFAULT_DISPLAY_TIME=5e3,GFdynamicFeedControl.DEFAULT_FADEOUT_TIME=1e3,GFdynamicFeedControl.DEFAULT_TRANSISTION_STEP=40,GFdynamicFeedControl.DEFAULT_HOVER_TIME=100,GFdynamicFeedControl.prototype.parseOptions_=function(e){this.options={numResults:GFdynamicFeedControl.DEFAULT_NUM_RESULTS,feedCycleTime:GFdynamicFeedControl.DEFAULT_FEED_CYCLE_TIME,linkTarget:google.feeds.LINK_TARGET_BLANK,displayTime:GFdynamicFeedControl.DEFAULT_DISPLAY_TIME,transitionTime:GFdynamicFeedControl.DEFAULT_TRANSISTION_TIME,transitionStep:GFdynamicFeedControl.DEFAULT_TRANSISTION_STEP,fadeOutTime:GFdynamicFeedControl.DEFAULT_FADEOUT_TIME,scrollOnFadeOut:!0,pauseOnHover:!0,hoverTime:GFdynamicFeedControl.DEFAULT_HOVER_TIME,autoCleanup:!0,transitionCallback:null,feedTransitionCallback:null,feedLoadCallback:null,collapseable:!1,sortByDate:!1,horizontal:!1,stacked:!1,title:null};if(e)for(var t in this.options)typeof e[t]!="undefined"&&(this.options[t]=e[t]);this.options.stacked||(this.options.collapseable=!1),this.options.displayTime=Math.max(200,this.options.displayTime),this.options.fadeOutTime=Math.max(0,this.options.fadeOutTime);var n=this.options.fadeOutTime/this.options.transitionStep;this.fadeOutDelta=Math.min(1,1/n),this.started=!1},GFdynamicFeedControl.prototype.setup_=function(e){if(e==null)return;this.nodes.container=e,window.ActiveXObject?this.ie=this[window.XMLHttpRequest?"ie7":"ie6"]=!0:document.childNodes&&!document.all&&!navigator.taintEnabled?this.safari=!0:document.getBoxObjectFor!=null&&(this.gecko=!0),this.feedControl=new google.feeds.FeedControl,this.feedControl.setLinkTarget(this.options.linkTarget),this.expected=this.feeds.length,this.errors=0;for(var t=0;t<this.feeds.length;t++){var n=new google.feeds.Feed(this.feeds[t].url);n.setResultFormat(google.feeds.Feed.JSON_FORMAT),n.setNumEntries(this.options.numResults),n.load(this.bind_(this.feedLoaded_,t))}},GFdynamicFeedControl.prototype.bind_=function(e){var t=this,n=[].slice.call(arguments,1);return function(){var r=n.concat([].slice.call(arguments));return e.apply(t,r)}},GFdynamicFeedControl.prototype.feedLoaded_=function(e,t){this.options.feedLoadCallback&&this.options.feedLoadCallback(t);if(t.error){++this.errors>=this.expected&&(this.nodes.container.innerHTML="Feed"+(this.expected>1?"s ":" ")+"could not be loaded.");return}this.feeds[e].title&&(t.feed.title=this.feeds[e].title),this.results.push(t),this.started?!this.options.horizontal&&this.options.stacked&&this.addResult_(this.results.length-1):(this.createSubContainers_(),this.displayResult_(0))},GFdynamicFeedControl.prototype.sortByDate_=function(e,t,n){var r=this.results[e].feed.entries[0].publishedDate,i=Date.parse(r),s=null;for(var o=0;o<this.results.length;o++){var u=this.results[o].feed.entries[0].publishedDate,a=Date.parse(u);if(i>a){s=o;break}}if(s==null){this.nodes.root.appendChild(t),this.nodes.root.appendChild(n),this.createListEntries_(e,n);return}var f=2+s*2,l=f+2,c=null,h=e+1,p=this.nodes.root.childNodes,d=p[f];this.nodes.root.insertBefore(t,d),this.nodes.root.insertBefore(n,d),this.results.splice(s,0,this.results[e]),this.results.splice(h,1);var v=p[l].nextSibling.childNodes;this.createListEntries_(s,n),s==0&&this.displayResult_(0),s+=1;for(var o=l;o<p.length;o+=2){var v=p[o].nextSibling.childNodes;for(var m=0;m<v.length;m++)v[m].onmouseover=this.bind_(this.listMouseOver_,s,m),v[m].onmouseout=this.bind_(this.listMouseOut_,s,m);s++}},GFdynamicFeedControl.prototype.addResult_=function(e){var t=this.results[e],n=this.createDiv_("gfg-subtitle");this.setTitle_(t.feed,n);var r=this.createDiv_("gfg-list");if(this.options.collapseable){var i=document.createElement("div");r.style.display="none",i.className="gfg-collapse-closed",n.appendChild(i),i.onclick=this.toggleCollapse(this,r,i),this.collapseElements.push({list:r,collapse:i})}var s=document.createElement("div");s.className="clearFloat",n.appendChild(s),this.options.sortByDate?this.sortByDate_(e,n,r):(this.nodes.root.appendChild(n),this.nodes.root.appendChild(r),this.createListEntries_(e,r))},GFdynamicFeedControl.prototype.displayResult_=function(e){this.resultIndex=e;var t=this.results[e];this.options.feedTransitionCallback&&this.options.feedTransitionCallback(t),this.options.title?this.setPlainTitle_(this.options.title):this.setTitle_(t.feed),this.clearNode_(this.nodes.entry),this.started&&!this.options.horizontal&&this.options.stacked?this.entries=t.feed.entries:this.createListEntries_(e,this.nodes.list),this.displayEntries_()},GFdynamicFeedControl.prototype.setPlainTitle_=function(e,t){var n=t||this.nodes.title;n.innerHTML=e},GFdynamicFeedControl.prototype.setTitle_=function(e,t){var n=t||this.nodes.title;this.clearNode_(n);var r=document.createElement("a");r.target=google.feeds.LINK_TARGET_BLANK,r.href=e.link,r.className="gfg-collapse-href",r.innerHTML=e.title,n.appendChild(r)},GFdynamicFeedControl.prototype.toggleCollapse=function(e,t,n){return function(){var r=e.collapseElements;for(var i=0;i<r.length;i++){var s=r[i];s.list.style.display="none",s.collapse.className="gfg-collapse-closed"}t.style.display="block",n.className="gfg-collapse-open"}},GFdynamicFeedControl.prototype.createListEntries_=function(e,t){var n=this.results[e].feed.entries;this.clearNode_(t);for(var r=0;r<n.length;r++){this.feedControl.createHtml(n[r]);var i="gfg-listentry ";i+=r%2?"gfg-listentry-even":"gfg-listentry-odd";var s=this.createDiv_(i),o=this.createLink_(n[r].link,n[r].title,this.options.linkTarget);s.appendChild(o),this.options.pauseOnHover&&(s.onmouseover=this.bind_(this.listMouseOver_,e,r),s.onmouseout=this.bind_(this.listMouseOut_,e,r)),n[r].listEntry=s,t.appendChild(s)}t==this.nodes.list&&(this.entries=n)},GFdynamicFeedControl.prototype.displayEntries_=function(){this.entryIndex=0,this.displayCurrentEntry_(),this.setDisplayTimer_(),this.started=!0},GFdynamicFeedControl.prototype.displayNextEntry_=function(){if(this.options.autoCleanup&&this.isOrphaned_()){this.cleanup_();return}if(++this.entryIndex>=this.entries.length){if(this.results.length>1){++this.resultIndex>=this.results.length&&(this.resultIndex=0),this.displayResult_(this.resultIndex);return}this.entryIndex=0}this.options.transitionCallback&&this.options.transitionCallback(this.entries[this.entryIndex]),this.displayCurrentEntry_(),this.setDisplayTimer_()},GFdynamicFeedControl.prototype.displayCurrentEntry_=function(){this.clearNode_(this.nodes.entry),this.current=this.entries[this.entryIndex].html,this.current.style.top="0px",this.nodes.entry.appendChild(this.current),this.createOverlay_();if(this.options.collapseable){var e=null;for(var t=0;t<this.results.length;t++)this.results[t].feed.entries==this.entries&&(e=this.results[t].feed.title);var n=this.collapseElements;for(var t=0;t<n.length;t++){var r=n[t],i=r.collapse.previousSibling.innerHTML,s=r.collapse;e==i&&(this.ie?s.click():s.onclick())}}if(this.currentList){var o="gfg-listentry ";o+=this.currentListIndex%2?"gfg-listentry-even":"gfg-listentry-odd",this.currentList.className=o}this.currentList=this.entries[this.entryIndex].listEntry,this.currentListIndex=this.entryIndex;var o="gfg-listentry gfg-listentry-highlight ";o+=this.currentListIndex%2?"gfg-listentry-even":"gfg-listentry-odd",this.currentList.className=o},GFdynamicFeedControl.prototype.listMouseHover_=function(e,t){var n=this.results[e],r=n.feed.entries[t].listEntry;r.selectTimer=null,this.clearTransitionTimer_(),this.clearDisplayTimer_(),this.resultIndex=e,this.entries=n.feed.entries,this.entryIndex=t,this.displayCurrentEntry_()},GFdynamicFeedControl.prototype.listMouseOver_=function(e,t){var n=this.results[e],r=n.feed.entries[t].listEntry,i=this.bind_(this.listMouseHover_,e,t);r.selectTimer=setTimeout(i,this.options.hoverTime)},GFdynamicFeedControl.prototype.listMouseOut_=function(e,t){var n=this.results[e],r=n.feed.entries[t].listEntry;r.selectTimer?(clearTimeout(r.selectTimer),r.selectTimer=null):this.setDisplayTimer_()},GFdynamicFeedControl.prototype.entryMouseOver_=function(e){this.clearDisplayTimer_(),this.transitionTimer&&(this.clearTransitionTimer_(),this.displayCurrentEntry_())},GFdynamicFeedControl.prototype.entryMouseOut_=function(e){this.setDisplayTimer_()},GFdynamicFeedControl.prototype.createOverlay_=function(){if(this.current==null)return;if(this.overlay==null){var e=this.createDiv_("gfg-entry");e.style.position="absolute",e.style.top="0px",e.style.left="0px",this.overlay=e}this.setOpacity_(this.overlay,0),this.nodes.entry.appendChild(this.overlay)},GFdynamicFeedControl.prototype.setDisplayTimer_=function(){this.displayTimer&&this.clearDisplayTimer_();var e=this.bind_(this.setFadeOutTimer_);this.displayTimer=setTimeout(e,this.options.displayTime)},GFdynamicFeedControl.timeNow=function(){var e=new Date;return e.getTime()},GFdynamicFeedControl.prototype.fadeOutEntry_=function(){if(this.overlay){var e=this.fadeOutDelta,t=this.options.transitionStep,n=GFdynamicFeedControl.timeNow(),r=n-this.lastTick;this.lastTick=n,e*=r/t;var i=this.overlay.opacity+e;this.setOpacity_(this.overlay,i);if(this.options.scrollOnFadeOut&&i>.5){var s=(i-.5)*2,o=Math.round(this.current.offsetHeight*s);this.current.style.top=o+"px"}if(i<1)return}this.clearTransitionTimer_(),this.displayNextEntry_()},GFdynamicFeedControl.prototype.setFadeOutTimer_=function(){this.clearTransitionTimer_(),this.lastTick=GFdynamicFeedControl.timeNow();var e=this.bind_(this.fadeOutEntry_);this.transitionTimer=setInterval(e,this.options.transitionStep)},GFdynamicFeedControl.prototype.clearTransitionTimer_=function(){this.transitionTimer&&(clearInterval(this.transitionTimer),this.transitionTimer=null)},GFdynamicFeedControl.prototype.clearDisplayTimer_=function(){this.displayTimer&&(clearTimeout(this.displayTimer),this.displayTimer=null)},GFdynamicFeedControl.prototype.createSubContainers_=function(){var e=this.nodes,t=this.nodes.container;this.clearNode_(t),this.options.horizontal?(t=this.createDiv_("gfg-horizontal-container"),e.root=this.createDiv_("gfg-horizontal-root"),this.nodes.container.appendChild(t)):e.root=this.createDiv_("gfg-root"),e.title=this.createDiv_("gfg-title"),e.entry=this.createDiv_("gfg-entry"),e.list=this.createDiv_("gfg-list"),e.root.appendChild(e.title),e.root.appendChild(e.entry);if(!this.options.horizontal&&this.options.stacked){var n=this.createDiv_("gfg-subtitle");e.root.appendChild(n),this.setTitle_(this.results[0].feed,n);if(this.options.collapseable){var r=document.createElement("div");r.className="gfg-collapse-open",n.appendChild(r),r.onclick=this.toggleCollapse(this,e.list,r),this.collapseElements.push({list:e.list,collapse:r}),e.list.style.display="block"}var i=document.createElement("div");i.className="clearFloat",n.appendChild(i)}e.root.appendChild(e.list),t.appendChild(e.root),this.options.pauseOnHover&&(e.entry.onmouseover=this.bind_(this.entryMouseOver_),e.entry.onmouseout=this.bind_(this.entryMouseOut_)),this.options.horizontal&&(e.branding=this.createDiv_("gfg-branding"),google.feeds.getBranding(e.branding,google.feeds.VERTICAL_BRANDING),t.appendChild(e.branding))},GFdynamicFeedControl.prototype.clearNode_=function(e){if(e==null)return;var t;while(t=e.firstChild)e.removeChild(t)},GFdynamicFeedControl.prototype.createDiv_=function(e,t){var n=document.createElement("div");return t&&(n.innerHTML=t),e&&(n.className=e),n},GFdynamicFeedControl.prototype.createLink_=function(e,t,n){var r=document.createElement("a");return r.href=e,r.innerHTML=t,n&&(r.target=n),r},GFdynamicFeedControl.prototype.clearResults_=function(){for(var e=0;e<this.results.length;e++){var t=this.results[e],n=t.feed.entries;for(var e=0;e<n.length;e++){var r=n[e];r.html=null,r.listEntry.onmouseover=null,r.listEntry.onmouseout=null,r.listEntry.selectTimer&&(clearTimeout(r.listEntry.selectTimer),r.listEntry.selectTimer=null),r.listEntry=null}}},GFdynamicFeedControl.prototype.isOrphaned_=function(){var e=this.nodes.root,t=!1;return!e||!e.parentNode?t=!0:this.options.horizontal&&!e.parentNode.parentNode&&(t=!0),t},GFdynamicFeedControl.prototype.cleanup_=function(){this.started=!1,this.clearDisplayTimer_(),this.clearTransitionTimer_(),this.clearResults_(),this.clearNode_(this.nodes.root),this.nodes.container=null},GFdynamicFeedControl.prototype.setOpacity_=function(e,t){if(e==null)return;t=Math.max(0,Math.min(1,t)),t==0?e.style.visibility!="hidden"&&(e.style.visibility="hidden"):e.style.visibility!="visible"&&(e.style.visibility="visible");if(this.ie){var n=Math.round(t*100);e.style.filter="alpha(opacity="+n+")"}e.style.opacity=e.opacity=t},GFgadget=GFdynamicFeedControl;