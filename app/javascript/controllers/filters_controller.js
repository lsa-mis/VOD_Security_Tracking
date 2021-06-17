import { Controller } from "stimulus"
const Choices = require('choices.js');
export default class extends Controller {
  static targets = ["form", "all_filters"]
  static classes = ['hidden']


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

  connect() {
    console.log("choices")
    this.class = this.hasHiddenClass ? this.hiddenClass : 'hidden'
    console.log(this.hiddenClass)
    console.log("class")
    console.log(this.class)

  }

  toggle() {
    console.log("toggle")
    this.all_filtersTarget.classList.toggle(this.class)
  }

  show() {
    console.log("show")
    this.all_filtersTarget.classList.remove(this.class)
  }

  hide() {
    console.log("hide")
    this.all_filtersTarget.classList.add(this.class)
  }

  submitForm(event) {
    console.log("submit")
    this.show()
  }

}