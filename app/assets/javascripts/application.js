// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require jquery-ui
//= require tether
//= require popper
//= require bootstrap-sprockets
//= require cocoon
//= require selectize
//= require seiyria-bootstrap-slider
//= require sortable
//= require highcharts
//= require chartkick

$(document).ready(function() {
  $(':input.select').selectize({
    selectOnTab: true,
  });

  $('tbody#character_skills').on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('select').selectize({
      selectOnTab: true,
      create: false,
    });
    $('.character-skill-fields').on('cocoon:after-insert', function(e, insertedItem) {
      $(this).children('td.csf').remove();
      insertedItem.find('select').selectize({
        selectOnTab: true,
        create: true,
      });
    });
  });

  $('tbody#character_perks').on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('select').selectize({
      selectOnTab: true,
      create: false,
    });
    $('.character-perk-fields').on('cocoon:after-insert', function(e, insertedItem) {
      $(this).children('td.cpf').remove();
      insertedItem.find('select').selectize({
        selectOnTab: true,
        create: true,
      });
    });
  });

  $('tbody#character_birthrights').on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('select').selectize({
      selectOnTab: true,
      create: false,
    });
    $('.character-birthright-fields').on('cocoon:after-insert', function(e, insertedItem) {
      $(this).children('td.cbf').remove();
      insertedItem.find('select').selectize({
        selectOnTab: true,
        create: true,
      });
    });
  });

  $('tbody#character_origins').on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('select').selectize({
      selectOnTab: true,
      create: false,
    });
    $('.character-origin-fields').on('cocoon:after-insert', function(e, insertedItem) {
      $(this).children('td.cof').remove();
      insertedItem.find('select').selectize({
        selectOnTab: true,
        create: true,
      });
    });
  });

  $('[data-toggle="tooltip"]').tooltip();

});
