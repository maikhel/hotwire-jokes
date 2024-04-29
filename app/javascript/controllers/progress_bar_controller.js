import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress-bar"
export default class extends Controller {
  static values = {
    limit: 0,
    actual: 0
  }
  static targets = ["jokesGrid", "progress", "count"]
  connect() {
    this.observer = new MutationObserver((mutationsList, _observer) => {
      for (let mutation of mutationsList) {
        if (mutation.type === 'childList') {
          this.increment()
        }
      }
    })

    this.observer.observe(this.jokesGridTarget, { childList: true, subtree: true })
  }

  increment() {
    this.actualValue++
    this.updateProgress()
    this.updateCount()
  }

  updateProgress() {
    let progress = (this.actualValue / this.limitValue) * 100
    this.progressTarget.style.width = `${progress}%`
  }

  updateCount() {
    this.countTarget.innerText = `${this.actualValue} / ${this.limitValue}`
  }
}
