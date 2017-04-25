module Api
  class NotesController < ApplicationController
    before_action :set_api_note, only: [:show, :update, :destroy]

    def for_tag
      @tag_name = params[:tag_name]

      the_tag = Tag.find_by(name: @tag_name)

      @api_notes = the_tag.notes
    end

    def index
      @api_notes = Note.all
    end


    def show
    end

    def create
      @api_note = Note.new(api_note_params)

      tags = params[:tags]

      tag_names = tags.split(',').map { |name| name.strip }

      tag_objects = tag_names.map { |tag_name| Tag.find_or_create_by(name: tag_name) }

      @api_note.tags = tag_objects


      if @api_note.save
        render :show, status: :created, location: api_note_url(@api_note) # [:api, @api_note]
      else
        render :error, status: :bad_request
      end
    end

    def update
      if @api_note.update(api_note_params)
        render :show, status: :ok, location: @api_note
      else
        render json: @api_note.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @api_note.destroy
    end

    private
      def set_api_note
        @api_note = Note.find(params[:id])
      end

      def api_note_params
        params.permit(:title, :body)
      end
  end
end
