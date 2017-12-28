$.fn.tagAutocomplete = function () {
  'use strict';

  function formatTag(tag) {
    return Select2.util.escapeMarkup(tag.name);
  }

  this.select2({
    placeholder: Spree.translations.tags_placeholder,
    minimumInputLength: 1,
    tokenSeparators: [','],
    multiple: true,
    tags: true,
    initSelection: function (element, callback) {
      var data = $(element.val().split(',')).map(function() {
        return { name: this, id: this };
      });
      callback(data);
    },
    createSearchChoice: function(term, data) {
      if ($(data).filter(function() {
        return this.name.localeCompare(term)===0;
      }).length===0) {
        return { id: term, name: term };
      }
    },
    formatResult:    formatTag,
    formatSelection: formatTag
  });
};

$(document).ready(function () {
  $('.list_picker').tagAutocomplete();
});
