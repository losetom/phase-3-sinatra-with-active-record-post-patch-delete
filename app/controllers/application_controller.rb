class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end

  delete '/reviews/:id' do
    # finding reviews by ID
    review = Review.find(params[:id])
    # deleting the review
    review.destroy
    #sending a response w/ the deleted review as JSON
    review.to_json
  end

  post '/reviews' do
    # create a new review in the database
    # params is a hash of key-value pairs coming from the body of the request
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id]
    )

    # sending back a response with the create review as JSON
    review.to_json
  end

  patch '/reviews/:id' do
    #finding the review by ID
    review = Review.find(params[:id])

    review.update(
      # updating the review 
      score: params[:score],
      comment: params[:comment]
    )

    # sencing back the updated review as JSON
    review.to_json
  end

end
