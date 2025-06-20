class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  logger = SemanticLogger["PostsController"]
  
  # GET /posts or /posts.json
  def index
    @posts = Post.all

    logger.info "Indexing posts"
  end

  # GET /posts/1 or /posts/1.json
  def show
    logger.info "Showing post"
    logger.debug @post.inspect
  end

  # GET /posts/new
  def new
    @post = Post.new
    logger.info "Creating post"
  end

  # GET /posts/1/edit
  def edit
    logger.info "Editing post"
    logger.debug @post.inspect
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        logger.info "Post saved"
        logger.debug @post.inspect
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        exception_in_span logger, StandardError.new("Post creation failed: #{@post.errors.full_messages.join(", ")}")
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        logger.info "Post updated"
        logger.debug @post.inspect
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        exception_in_span logger, StandardError.new("Post update failed: #{@post.errors.full_messages.join(", ")}")
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    logger.info "Destroying post #{@post.id}"

    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :author, :title, :content ])
    end
end
