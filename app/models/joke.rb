class Joke < ApplicationRecord
  PER_PAGE = 9

  belongs_to :jokes_request

  validates :body, presence: true

  after_create_commit ->(joke) do
    broadcast_replace_to([ joke.jokes_request, "jokes_count" ], target: "jokes_count", partial: "jokes_requests/jokes_count", locals: { jokes_request: joke.jokes_request })

    add_new_jokes_to_show_view(joke)
  end

  private

  def pagy_for(jokes_count, page_num)
    Pagy.new(count: jokes_count, page: page_num, items: PER_PAGE, link_extra: 'data-turbo-action="advance"')
  end

  def add_new_jokes_to_show_view(joke)
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
