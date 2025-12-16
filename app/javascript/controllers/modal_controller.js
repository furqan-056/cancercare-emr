import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.classList.remove('hidden');
  }

  close(e) {
    e.preventDefault();
    
    this.element.classList.add('hidden');
  }

  closeOnOutsideClick(e) {
    if (e.target === this.element) {
      this.close(e);
    }
  }
}
