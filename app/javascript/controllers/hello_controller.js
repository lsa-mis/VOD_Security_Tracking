// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["sensitive_data_system_type", "system_device"]

  connect() {
    // this.outputTarget.textContent = 'Hello, Stimulus!'
    console.log("hello from StimulusJS - hell!!!!!")
    // var type_val = this.targets.find("sensitive_data_system_type").value();
    // console.log("value: ")
    // console.log(type_val)

    // var type = this.sensitive_data_system_typeTarget
    // console.log("type: ")
    // console.log(type)
    // var val = type.value
    // console.log("val: ")

    // console.log(val)

  }

  display_device() {
    alert("display device")
    var type = this.sensitive_data_system_typeTarget.value
    console.log("type: ")
    console.log(type)
    if (type == 1) {
      this.system_deviceTarget.classList.toggle("session--hide")
    }
  }
}
