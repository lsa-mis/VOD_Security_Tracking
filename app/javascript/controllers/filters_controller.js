import { Controller } from "@hotwired/stimulus"
// const Choices = require('choices.js');
export default class FiltersController extends Controller {

  clearFilters() {
    this.element.reset()
  }
}
