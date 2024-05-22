import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="progress-bar"
export default class extends Controller {
    static values = {
        limit: 0,
        actual: 0,
    }
    static targets = ["progress", "count"]
    connect() {
        addEventListener("turbo:before-stream-render", ((event) => {
            const fallbackToDefaultActions = event.detail.render

            event.detail.render = (streamElement) => {
                if (streamElement.action === "append" && streamElement.target === "jokes_grid") {
                    this.increment()
                }
                fallbackToDefaultActions(streamElement)
            }
        }))
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
