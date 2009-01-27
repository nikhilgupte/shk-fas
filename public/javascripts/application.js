function disable_flash_messages() {
  $$('div.flash_message div').each(function(e) {Effect.Fade(e)});
}
