# frozen_string_literal: true

module LiveView
  module JokesObserver
    PER_PAGE = 9

    extend ActiveSupport::Concern

    included do
      after_create_commit ->(joke) do
        update_jokes_count_on_show_view(joke)
        update_jokes_progress_bar_on_show_view(joke)
        update_jokes_on_show_view(joke)
      end

      private

      def pagy_for(jokes_count, page_num)
        Pagy.new(count: jokes_count, page: page_num, items: PER_PAGE, link_extra: 'data-turbo-action="advance"')
      end

      def update_jokes_count_on_show_view(joke)
        broadcast_replace_to([ joke.jokes_request, "jokes_count" ], target: "jokes_count",
                            partial: "jokes_requests/jokes_count", locals: { jokes_request: joke.jokes_request })
      end

      def update_jokes_progress_bar_on_show_view(joke)
        broadcast_replace_to([ joke.jokes_request, "jokes_progress_bar" ], target: "jokes_progress_bar",
                            partial: "jokes_requests/jokes_progress_bar", locals: { jokes_request: joke.jokes_request })
      end

      def update_jokes_on_show_view(joke)
        jokes_count = joke.jokes_request.jokes.size
        last_page = jokes_count / PER_PAGE + 1

        if jokes_count % PER_PAGE ==  1 # change page to next one
          broadcast_replace_to([ joke.jokes_request, "jokes" ], target: "jokes_grid", partial: "jokes_requests/empty_jokes_grid")
          broadcast_append_to([ joke.jokes_request, "jokes" ], target: "jokes_grid", partial: "jokes/joke", locals: { joke: joke })
          broadcast_replace_to([ joke.jokes_request, "jokes_pagination" ], target: "jokes_pagination",
                              partial: "jokes_requests/jokes_pagination", locals: { pagy: pagy_for(jokes_count, last_page) })
        else
          # just add one more joke
          broadcast_append_to([ joke.jokes_request, "jokes" ], target: "jokes_grid", partial: "jokes/joke", locals: { joke: joke })
        end
      end
    end
  end
end
