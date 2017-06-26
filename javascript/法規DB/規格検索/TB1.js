(function(){
    //タイヤ区分
    $('#ChkTyre01').prop('checked', true);
    //section
    $('#SectionWidthNm').val('235');
    //ratio
    $('#AspectRatioNm').val('60');
    //構造記号
    $('#ConstructionCode').val('R');
    //リム
    $('#RimWidthNm').val('17.5');
    //LI1
    $('#LoadIndexSingleTyres').val('125');
    //LI2
    $('#LoadIndexDualTyres').val('122');
    
    //規格情報検索
    $('#search').click();
})()