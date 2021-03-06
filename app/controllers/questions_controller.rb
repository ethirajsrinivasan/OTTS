class QuestionsController < ApplicationController
    
    before_filter :authenticate_student! 

	def index 
		@questions=Question.all
		@questions_count=@questions.count
		@questions=@questions.paginate(:page => params[:page], :per_page => 5) 
	end 

	def new
		@question=Question.new
	end

	def create 
		@question=Question.new(params[:question])	
		if @question.save
			redirect_to @question,notice: 'Question successfully saved'
		else 
			render action: "new"
		end
	end
	
	def show
		@question=Question.find(params[:id])
	end 
	
	def edit
		@question=Question.find(params[:id])
	end
	
	def update
		@question=Question.find(params[:id])
		if @question.update_attributes(params[:question])
			redirect_to @question
		else
			render action: "edit"
		end
	end

	def destroy
	@question = Question.find(params[:id])
	@question.destroy
	redirect_to action: "index"
	end 

	def authenticate_student!
		if current_user.role=="Student"
			redirect_to student_index_path,notice: "you dont have the permission to see this page"	
		end
	end

	def download
	  	@questions = Question.order(:id)
	  	respond_to do |format|
	    format.csv { send_data @questions.to_csv }
	    format.xls # { send_data @products.to_csv(col_sep: "\t") }
	  	end
	end

	def import
    Question.import(params[:file])
    redirect_to questions_path, notice: "Questions imported."
  	end
end
