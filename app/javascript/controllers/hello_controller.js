// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

// import { Controller } from 'stimulus';
// export default class extends Controller {
//   static targets = ["heading"]

//   connect() {
//     console.log("hello from StimulusJS")
//   }

//   greet() {
//     console.log("click")
//     this.headingTarget.innerHTML = "Hello World"
//   }
// }

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["sensitive_data_system_type", "system_device"]

  connect() {
    console.log("hello from StimulusJS - hell!!!!!")
    this.display_device()
  }

  display_device() {
    console.log("display device")
    var type = this.sensitive_data_system_typeTarget.value
    console.log("type: ")
    console.log(type)
    if (type == 1) {
      this.system_deviceTarget.classList.add("device--display")
      this.system_deviceTarget.classList.remove("device--hide")
    }
    else {
      this.system_deviceTarget.classList.add("device--hide")
      this.system_deviceTarget.classList.remove("device--display")
    }
  }
}