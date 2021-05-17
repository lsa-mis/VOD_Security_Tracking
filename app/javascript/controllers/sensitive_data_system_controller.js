import { Controller } from 'stimulus';
export default class extends Controller {
    // static targets = ["system_type", "system_device"]

    // initialize() {
    //     const context = require.context("../controllers", true, /.js$/)
    //     console.log("controller definitions:", definitionsFromContext(context))
    //     console.log("Stimulus at your service!")
    //     const type = this.targets.find("system_type").value;
    //     console.log(type)
    // this.updateQueryParams()
    // this.toggleLoading()
    // }
    connect() {
        console.log("hello from my controller")
        //     var systemtype = this.checkboxTargets.filter(checkbox => checkbox.checked)
        //     checked.forEach((el) => {
        //       if (el.dataset.index == 0) {
        //         this.appendMessage()
        //       }
        //       if (el.dataset.index > 0) {
        //         this.showSession(el.dataset.index)
        //         this.showCourses(el.dataset.index)
        //       }system_type
        //     })
    }
}