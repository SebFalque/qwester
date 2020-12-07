require 'qwester/question'

module Qwester

  ActiveAdmin.register Questionnaire do

    menu_label = 'Questionnaires'
    # menu_label = "Qwester #{menu_label}" unless Qwester.active_admin_menu
    menu_label = "#{menu_label}" unless Qwester.active_admin_menu
    menu :parent => Qwester.active_admin_menu, :label => menu_label

    config.batch_actions = false

    if Qwester.rails_four?
      permit_params :title,
                    :description,
                    :button_image,
                    :must_complete,
                    question_ids: []
    end


    index do
      column :image do |questionnaire|
        image_tag(questionnaire.button_image.url(:thumbnail))
      end
      column :title
      column :questions do |questionnaire|
        questionnaire.questions.count
      end
      column :must_complete do |questionnaire|
        questionnaire.must_complete? ? 'Yes' : 'No'
      end
      #default_actions
      actions
    end

    form do |f|
      f.inputs "Details" do
        f.input :title
        if defined?(Ckeditor)
          f.input :description, :as => :ckeditor, :input_html => { :height => 100 }
        else
          f.input :description, :input_html => { :rows => 3}
        end
        f.input :must_complete
        f.input :button_image, :as => :file, :hint => f.template.image_tag(f.object.button_image.url(:link))
        f.input :questions, :as => :check_boxes, :collection => Question.all
      end
      f.actions
    end

    controller do
      def permitted_params
        params.permit(
          qwester_questionnaire: [
            :title, :description, :button_image, :must_complete,
            {question_ids: []}
          ]
        )
      end
    end unless Qwester.rails_three? || Qwester.rails_four?

    show do
      div do
        sanitize(qwester_questionnaire.description.html_safe ) if qwester_questionnaire.description.present?
      end

      div do
        image_tag qwester_questionnaire.button_image.url(:link)
      end

      div do
        h3 'Questions'
        para("#{qwester_questionnaire.must_complete? ? 'A' : 'Not a'}ll must be completed")
        ul :id => 'question_list'
        qwester_questionnaire.questions.each do |question|
          li do
            text = [question.title]
            text << link_to('Up', move_up_admin_qwester_questionnaire_path(qwester_questionnaire, :question_id => question)) unless qwester_questionnaire.first?(question)
            text << link_to('Down', move_down_admin_qwester_questionnaire_path(qwester_questionnaire, :question_id => question)) unless qwester_questionnaire.last?(question)
            text.join(' ').html_safe
          end
        end
      end
    end

    member_action :move_up do
      questionnaire = Questionnaire.find(params[:id])
      question = Question.find(params[:question_id])
      questionnaire.move_higher(question)
      redirect_to admin_qwester_questionnaire_path(questionnaire)
    end

    member_action :move_down do
      questionnaire = Questionnaire.find(params[:id])
      question = Question.find(params[:question_id])
      questionnaire.move_lower(question)
      redirect_to admin_qwester_questionnaire_path(questionnaire)
    end




  end if defined?(ActiveAdmin)

end
