import { Controller } from "@hotwired/stimulus";
import "jquery";
import "select2";  

// O jQuery é carregado globalmente pela importação do importmap
export default class extends Controller {
  connect() {
    // Verifique se o jQuery foi carregado corretamente
    if (typeof $ !== 'undefined') {
        document.addEventListener("turbo:load", function() {
                 $( '.select2' ).select2( {
                 theme: "bootstrap-5",
                 width: $( this ).data( 'width' ) ? $( this ).data( 'width' ) : $( this ).hasClass( 'w-100' ) ? '100%' : 'style',
                 placeholder: $( this ).data( 'placeholder' ),
             } );
             });
    } else {
      console.error("jQuery não foi carregado.");
    }
  }
}

