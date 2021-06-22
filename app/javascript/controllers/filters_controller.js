import { Controller } from "stimulus"
const Choices = require('choices.js');
export default class extends Controller {
  static targets = ["displayfilters"]
  static values = { visible: Boolean }
  static classes = ["hidden"]




  //   initialize(){
  //     // const element = document.querySelector('.js-choice');
  //     const element = this.choiceTarget
  //     const choices = new Choices(element, {
  //       placeholder: true,
  //       // shouldSort: false,
  //       searchFields: ['label'],
  //       removeItemButton: true,
  //       maxItemCount: 2
  //     })
  //   }

  // connect() {
  //   console.log("choices")
  //   this.updateHiddenClass()

  // }
  updateHiddenClass() {
    console.log("updateHiddenClass")
    // console.log(this.displayfiltersTarget.classList)
    // console.log(this.hiddenClass)
    // console.log(this.visibleValue)
    this.displayfiltersTarget.classList.toggle(this.hiddenClass, !this.visibleValue)
    this.visibleValue = !this.visibleValue
  }

  submitForm(event) {
    let isValid = this.validateForm(this.formTarget);
    if (!isValid) {
      this.system_deviceTarget.append("Add serial number or hostname");
      event.preventDefault();
    }
  }

}