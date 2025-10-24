$(function(){
	$('.uploadBtn').on('click',function(){
		$('#upload').click();
	})
	
	$('#upload').fileupload({
		dropZone: $(document),
    pasteZone: null,
    autoUpload: true,
    sequentialUploads: true,

		dataType: 'json',
		url:'./upload.html',
		type: 'POST',
		add: function(e,data){
			console.log(data,'添加文件时执行的操作');
			var $li = '<li><i class="attention"></i><p class="songName">'+data.files[0].name+'</p><div class="progress"><div class="bar"></div></div></li>';
			data.context = $($li).appendTo('#uploadingList');
			console.log(data.context);
			var jqXHR = data.submit();

		},
		progress: function (e, data) {//上传进度  
		  var progress = parseInt(data.loaded / data.total * 100, 10);
		  console.log(progress,data);
		  // $(".progress .bar").css("width", progress + "%");  
		  data.context.find(".bar").css("width", progress + "%");
		},
		done:function(e,data){
			console.log('上传完毕');
		},
		always: function(e, data) {
			// 每次传输后（包括成功，失败，被拒执行的回调）
      data.context.remove();
      var $li = $('<li />');
      $li.html('<p class="songName">'+data.files[0].name+'</p><p class="songSize">'+formatFileSize(data.files[0].size)+'</p>');
      $('#uploadingDone').append($li);
    }
	})
})
function formatFileSize(bytes) {
  if (bytes >= 1000000000) {
    return (bytes / 1000000000).toFixed(2) + ' GB';
  }
  if (bytes >= 1000000) {
    return (bytes / 1000000).toFixed(2) + ' MB';
  }
  return (bytes / 1000).toFixed(2) + ' KB';
}