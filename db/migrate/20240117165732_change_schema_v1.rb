class ChangeSchemaV1 <  ActiveRecord::Migration[6.0]
def change

  create_table :user_terms_acceptances , comment: 'Stores records of users accepting terms and conditions' do |t|
    
      
        
        t.datetime :accepted_at  
      
    
    t.timestamps null: false
  end


  create_table :users , comment: 'Stores user account information' do |t|
    
      
        
        t.string :password_hash  
      
    
      
        
        t.string :email  
      
    
      
        
        t.boolean :email_verified  
      
    
      
        
        t.string :username  
      
    
    t.timestamps null: false
  end


  create_table :terms_and_conditions , comment: 'Stores terms and conditions versions' do |t|
    
      
        
        t.string :version  
      
    
      
        
        t.text :content  
      
    
      
        
        t.date :effective_date  
      
    
    t.timestamps null: false
  end


  create_table :email_verification_tokens , comment: 'Stores tokens for email verification process' do |t|
    
      
        
      
        
        t.string :token  
      
    
      
        
        t.datetime :expires_at  
      
    
    t.timestamps null: false
  end


  create_table :security_questions , comment: 'Stores security questions for user accounts' do |t|
    
      
        
        t.string :question  
      
    
    t.timestamps null: false
  end


  create_table :user_security_answers , comment: 'Stores user's answers to security questions' do |t|
    
      
        
      
        
        t.string :answer  
      
    
      
        
    t.timestamps null: false
  end


  add_reference :email_verification_tokens, :user, foreign_key: true


  add_reference :user_security_answers, :user, foreign_key: true


  add_reference :user_security_answers, :security_question, foreign_key: true


end
end