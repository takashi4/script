var scr = document.createElement('script');
scr.src='//code.jquery.com/jquery-1.12.4.min.js';
document.body.appendChild(scr);
var doc = window.frames[4].document;
var str = "";
Math.__proto__.mod = function(x,y){return x%y};

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
      var dt = parseInt((t2-t1)/1000); // �b�ɕϊ�
      var dh = Math.floor(dt/3600) -1; // �x�e���Ԃ͈���
      var dm = Math.mod(dt, 3600) / 60;
      var dH = dt/3600 - 1; //8.75���� �̂悤�ɕ\��

      console.log(ymd + ' ' +dh+'����'+dm+'��'+'('+dH+') ');
      str += ymd + ' ' +dh+'����'+dm+'��'+'('+dH+")\r\n";
}}});
alert(str);
}, 1000);



