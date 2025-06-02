require "opentelemetry/sdk"

class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts
  def index
    OtelTracer.in_span("PostsController#index") do |span|
      @posts = Post.all

      span.add_attributes({ "nl.zorgdomein.boards.posts.count" => @posts.count })
    end
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    OtelTracer.in_span("PostsController#create") do |span|
      @post = Post.new(post_params)

      if @post.save
        span.add_attributes({ "nl.zorgdomein.boards.post.id" => @post.id })
        span.add_event("Post saved successfully")
        redirect_to @post, notice: "Post was successfully created."
      else
        set_otel_error(span, "save")
        render :new, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    OtelTracer.in_span("PostsController#update", attributes: { "nl.zorgdomein.boards.post.id" => @post.id }) do |span|
      if @post.update(post_params)
        span.add_event("Post updated successfully")
        redirect_to @post, notice: "Post was successfully updated.", status: :see_other
      else
        set_otel_error(span, "update")
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # DELETE /posts/1
  def destroy
    OtelTracer.in_span("PostsController#destroy", attributes: { "nl.zorgdomein.boards.post.id" => @post.id }) do |span|
      @post.destroy!
      redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.expect(post: [:name, :title, :content])
  end

  def set_otel_error(span, action)
    span.status = OpenTelemetry::Trace::Status.error("Post #{action} failed" + @post.errors.full_messages.join(", "))
  end
end
