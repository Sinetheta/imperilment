module WebHook::Event
  class NewAnswer
    def initialize answer
      @answer = answer
    end

    def serialize
      as_json.to_json
    end

    def as_json
      @answer.as_json(
        except: :correct_question,
        include: {
          category: { only: [:id, :name] }
        }
      ).tap do |h|
        h['url'] = reply_url
      end
    end

    # The app url where contestants can visit to respond to the clue.
    def reply_url
      Rails.application.routes.url_helpers.game_answer_url(@answer.game, @answer)
    end
  end
end
