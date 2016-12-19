var scr = document.createElement('script');
scr.src='//code.jquery.com/jquery-1.12.4.min.js';
document.body.appendChild(scr);
var doc = window.frames[4].document;
setTimeout(function(){$("#TBL tbody tr", doc).each(function(){
  var tr = $(this);
 if (tr.attr('style')!='display:none' && tr.attr('class')!='HEADER') {
   var tds = $(tr.find('td'));
   var ymd = tds.eq(1).text().replace(/\s/g, '');
   var start = tds.eq(5).text().replace(/\s/g, '');
   var end   = tds.eq(6).text().replace(/\s/g, '');

   if (ymd && start && end) {
      var t1 = new Date(ymd + ' ' + start);
      var t2 = new Date(ymd + ' ' + end);
      
      console.log(ymd + ' ' +(Math.floor((t2-t1)/3600000)-1)+'ŽžŠÔ'+Math.floor((t2-t1)%3600000)/60000+'•ª'
         +'('+((t2-t1)/3600000-1)+') '
      );
}}});}, 1000);



