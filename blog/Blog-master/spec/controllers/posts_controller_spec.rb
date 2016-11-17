require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe '#index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe '#new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
    it 'instantiates a new post object' do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe '#create' do
    context 'with valid params' do
      def valid_request
        post :create, params: { post: attributes_for(:post) }
      end
      it 'saves a record to the database' do
        count_before = Post.count
        valid_request
        count_after = Post.count
        expect(count_after). to eq(count_before +1)
      end
      it 'redirects to the post show page' do
        valid_request
        expect(response).to redirect_to(post_path(Post.last))
      end
    end
    context 'with invalid params' do
      def invalid_request
        post :create, params: { post: attributes_for(:post, title: nil) }
      end
      it 'doesn\'t save a record to the database' do
        count_before = Post.count
        invalid_request
        count_after = Post.count
        expect(count_after). to eq(count_before)
      end
      it 'renders the new template' do
        invalid_request
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#show' do
    it 'renders the show template' do
      post = create(:post)
      get :show, params: { id: post.id }
      expect(response).to render_template(:show)
    end
    it 'sets an instance variable with the post whose id has passed' do
      post = create(:post)
      get :show, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe '#edit' do
    it 'renders the edit template' do
      post = create(:post)
      get :edit, params: { id: post.id }
      expect(response).to render_template(:edit)
    end
    it 'sets an instance variable with the post whose id has passed' do
      post = create(:post)
      get :edit, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe '#delete' do
    it 'sets an instance variable with the post whose id has passed' do
      post = create(:post)
      delete :destroy, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
    it 'removes a record from the database' do
      post = create(:post)
      count_before = Post.count
      delete :destroy, params: { id: post.id }
      count_after = Post.count
      expect(count_after). to eq(count_before -1)
    end
    it 'redirects to the post show page' do
      post = create(:post)
      delete :destroy, params: { id: post.id }
      expect(response).to redirect_to(post_path)
    end
  end

  describe '#update' do
    def valid_request
      @post = create(:post)
      patch :update, params: { id: @post.id, post: @post.attributes }
    end
    it 'sets an instance variable with the post whose id has passed' do
      valid_request
      expect(assigns(:post)).to eq(@post)
    end
    context 'with valid params' do
      it 'saves a record to the database' do
        post = create(:post)
        patch :update, params: { id: post.id, post: attributes_for(:post, title: 'Newtitle') }
        post.reload
        expect(post.title).to eq('Newtitle')
      end
      it 'redirects to the post show page' do
        valid_request
        expect(response).to redirect_to(post_path(Post.last))
      end
    end
    context 'with invalid params' do
      def invalid_request
        @post = create(:post)
        patch :update, params: { id: @post.id, post: attributes_for(:post, title:nil) }
      end
      it 'doesn\'t save a record to the database' do
      invalid_request
        expect(@post.title).not_to eq(nil)
      end
      it 'renders the new template' do
        invalid_request
        expect(response).to render_template(:edit)
      end
    end
  end

  end
