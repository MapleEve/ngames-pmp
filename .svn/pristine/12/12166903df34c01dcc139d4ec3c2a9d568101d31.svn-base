$.fn.observe = function(seconds, callback){
  return this.each(function(){
    var form = this, dirty = false;

    $(form.elements).change(function(){
      dirty = true;
    });

    setInterval(function(){
      if(typeof(CKEDITOR) !== "undefined") {
        for(var instanceName in CKEDITOR.instances) {
          if(CKEDITOR.instances[instanceName].checkDirty()) {
            $('textarea#' + instanceName).val(CKEDITOR.instances[instanceName].getData());
            dirty = true;
            CKEDITOR.instances[instanceName].resetDirty();
          };
        }
      }
      if (dirty) callback.call(form);
      dirty = false;
    }, seconds * 1000);
  });
};