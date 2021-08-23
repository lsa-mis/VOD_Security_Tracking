import { Controller } from "stimulus"
export default class InfoToggleController extends Controller {
  static targets = ["info_text_area", "info_text_short_area"]
  // connect(){
  //   console.log ("lskejojsdnfl;kasngpioasdjgoiasdj")
  // }

  toggle() {
    // console.log ("you are in the money")
    this.info_text_areaTarget.classList.add("device-error--display")
    this.info_text_areaTarget.classList.remove("device-error--hide")
    this.info_text_short_areaTarget.classList.add("device-error--hide")
    this.info_text_short_areaTarget.classList.remove("device-error--display")
  }

  toggle2() {
    // console.log ("you are in the money")
    this.info_text_areaTarget.classList.add("device-error--hide")
    this.info_text_areaTarget.classList.remove("device-error--display")
    this.info_text_short_areaTarget.classList.add("device-error--display")
    this.info_text_short_areaTarget.classList.remove("device-error--hide")
  }
}
