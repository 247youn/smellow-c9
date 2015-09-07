class HomeController < ApplicationController
    def index
    
    end
    
    def evalpage
    	unless user_signed_in?
    	    redirect_to '/'
    	else
    	    
			@user = User.find(current_user.id)
			@evaluations = Evaluation.where(user_id: @user.id)
			@products = Product.all
			@evaluations.each do |evaluation|
				if evaluation.rate != 5
	 				@products = @products.where.not(id: evaluation.product_id)
	 			end
			end
    	end
		
	end
	
	def list_bodyclean
		@products = Product.all
		@user = User.find(current_user.id)
		@evaluations = Evaluation.where(user_id: @user.id)
	
	end
	
	def mypage
	    unless user_signed_in?
	        redirect_to '/'
	    else
	    	@users = User.all
	        @user = User.find(current_user.id)
	        @evaluations = Evaluation.where(user_id: @user.id)
	        @products = Product.all
	        @comments = Comment.all
	    end
	end
	
	def admin_import_product_csv
	    
	end
	
	def admin_export_evaluation_csv
		@products = Product.all
		users = User.all
		@hash_users = Hash.new
		users.each do |user|
			arr_product_of_user = Array.new()
			evaluations_of_user = Evaluation.where(user_id: user.id)
			evaluations_of_user.each do |evaluation_of_user|
				product_name = evaluation_of_user.product_id
				arr_product_of_user.push(product_name)
			end
			@hash_users[user.email]=arr_product_of_user
		end
	end
	
	attr_accessor :name, :brand, :imglink, :category
	require 'csv'
	def admin_import_product_csv_post
		file = params[:file]
		CSV.foreach(file.path, headers: true, :encoding => 'cp949:utf-8') do |row|
			p = Product.new
			p.name = row[0]
			p.brand = row[1]
			p.imglink = row[2]
			p.category = row[3]
			p.save
		end
	end
	
	def evalrate
		@product_id = params[:product_id]
		@user_id = User.find(current_user.id).id
		@rate = params[:rate]
	
		if Evaluation.where(product_id: @product_id, user_id: @user_id).blank?
			e = Evaluation.new
			e.user_id = @user_id
			e.product_id = @product_id
			e.rate = @rate
			e.save
		elsif Evaluation.where(product_id: @product_id, user_id: @user_id, rate: @rate).present?
			e = Evaluation.where(product_id: @product_id, user_id: @user_id, rate: @rate).first
			e.destroy
		else
			e = Evaluation.where(product_id: @product_id, user_id: @user_id).first
			e.user_id = @user_id
			e.product_id = @product_id
			e.rate =@rate
			e.save
		end
		render :nothing => true
	end

	def post_comment
		@product_id = params[:product_id]
		@user_id = User.find(current_user.id).id
		@comment_text = params[:comment_text]
		
		
		c = Comment.new
		c.product_id = @product_id
		c.user_id =  @user_id
		c.comment_text = @comment_text
		c.save

		render :nothing => true
	end
end

