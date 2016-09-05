# encoding: utf-8

=begin
   Copyright 2016 Telegraph-ai

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
=end

module Houston
	def self.included(base)
		Bot.log.info "loading Houston add-on"
		messages={
			:en=>{
				:houston=>{
					:no=>"Non",
					:yes=>"Oui",
					:welcome_answer=>"/start",
					:welcome=><<-END,
Bonjour %{firstname} !
Je suis Houston. #{Bot.emoticons[:blush]}
Mon rôle est de noter votre prorité pour améliorer la France.
Je vous propose à la fin de notre conversation une image à relayer sur les réseaux sociaux.
Mais assez discuté, commençons !
END
					:menu_answer=>"#{Bot.emoticons[:home]} Accueil",
					:menu=><<-END,
Que voulez-vous faire ? Utilisez les boutons du menu ci-dessous pour m'indiquer ce que vous souhaitez faire.
END
					:ask_img_answer=>"Retrouver mon message",
					:ask_img=><<-END,
Je recherche votre demande...
END
					:get_img=><<-END,
Voici votre demande !
END
					:bad_img=><<-END,
Je suis navré que l'image ne vous plaise pas.  #{Bot.emoticons[:confused]}
Reprenons. 
END
					:good_img=><<-END,
Génial ! Je vous laisse alors partager cette image sur vos réseaux sociaux ! 
END
					:ask_wrong=><<-END,
Hmmm... Je ne retrouve pas votre priorité... #{Bot.emoticons[:confused]}
Reprenons.
END
					:ask_txt_answer=>"Ecrire mon message",
					:ask_txt=><<-END,
D'après vous, quelle est la priorité en France ?
END
					:end=><<-END,
J'espère que vous êtes satifait(e) de moi. À bientôt !
END
				}
			},
			:fr=>{
				:houston=>{
					:no=>"Non",
					:yes=>"Oui",
					:welcome_answer=>"/start",
					:welcome=><<-END,
Bonjour %{firstname} !
Je suis Houston. #{Bot.emoticons[:blush]}
Mon rôle est de noter votre prorité pour améliorer la France.
Je vous propose à la fin de notre conversation une image à relayer sur les réseaux sociaux.
Mais assez discuté, commençons !
END
					:menu_answer=>"#{Bot.emoticons[:home]} Accueil",
					:menu=><<-END,
Que voulez-vous faire ? Utilisez les boutons du menu ci-dessous pour m'indiquer ce que vous souhaitez faire.
END
					:ask_img_answer=>"Retrouver mon message",
					:ask_img=><<-END,
Je recherche votre demande...
END
					:get_img=><<-END,
Voici votre demande !
END
					:bad_img=><<-END,
Je suis navré que l'image ne vous plaise pas.  #{Bot.emoticons[:confused]}
Reprenons. 
END
					:good_img=><<-END,
Génial ! Je vous laisse alors partager cette image sur vos réseaux sociaux ! 
END
					:ask_wrong=><<-END,
Hmmm... Je ne retrouve pas votre priorité... #{Bot.emoticons[:confused]}
Reprenons.
END
					:ask_txt_answer=>"Ecrire mon message",
					:ask_txt=><<-END,
D'après vous, quelle est la priorité en France ?
END
					:end=><<-END,
J'espère que vous êtes satifait(e) de moi. À bientôt !
END
				}
			}
		}
		screens={
			:houston=>{
				:welcome=>{
					:answer=>"houston/welcome_answer",
					:disable_web_page_preview=>true,
					:callback=>"houston/welcome",
					:jump_to=>"houston/menu"
				},
				:menu=>{
					:answer=>"houston/menu_answer",
					:callback=>"houston/menu",
					:parse_mode=>"HTML",
					:kbd=>["houston/ask_img","houston/ask_txt"],
					:kbd_options=>{:resize_keyboard=>true,:one_time_keyboard=>false,:selective=>true}
				},
				
				:get_img=>{
					:callback=>"houston/get_img",
					:parse_mode=>"HTML",
					:kbd=>["houston/bad_img","houston/good_img"],
					:kbd_options=>{:resize_keyboard=>true,:one_time_keyboard=>false,:selective=>true}
				},
				:bad_img=>{
					:answer=>"houston/no",
					:jump_to=>"houston/ask_txt"
				},
				:good_img=>{
					:answer=>"houston/yes",
					:jump_to=>"houston/end"
				},
				
				:ask_img=>{
					:answer=>"houston/ask_img_answer",
					:callback=>"houston/ask_img"
				},
				:ask_wrong=>{
					:jump_to=>"houston/menu"
				},
				:ask_txt=>{
					:answer=>"houston/ask_txt_answer",
					:callback=>"houston/ask_txt"
				}
			}
		}
		Bot.updateScreens(screens)
		Bot.updateMessages(messages)
		Bot.addMenu({:houston=>{:menu=>{:kbd=>"houston/menu"}}})
	end

	def houston_welcome(msg,user,screen)
		Bot.log.info "#{__method__}"
		screen=self.find_by_name("houston/menu",self.get_locale(user))
		return self.get_screen(screen,user,msg)
	end

	def houston_menu(msg,user,screen)
		Bot.log.info "#{__method__}"
		screen[:kbd_del]=["houston/menu"] #comment if you want the houston button to be displayed on the houston menu
		user.next_answer('answer')
		return self.get_screen(screen,user,msg)
	end

	def houston_ask_img(msg,user,screen)
		Bot.log.info "#{__method__}"
		# search for an image
		# if image exists:
		if 1==0 then
			screen=self.find_by_name("houston/get_img",self.get_locale(user))
		else
			screen=self.find_by_name("houston/ask_wrong",self.get_locale(user))
		end
		return self.get_screen(screen,user,msg)
	end
	
	def houston_ask_txt(msg,user,screen)
		Bot.log.info "#{__method__}"
		user.next_answer('free_text',1,"houston_save_txt")
		return self.get_screen(screen,user,msg)
	end

	def houston_save_txt(msg,user,screen)
		txt=user.state['buffer']
		Bot.log.info "#{__method__}: #{txt}"
		# process the text
		# TODO
		return self.houston_get_img(self.get_locale(user), screen)
	end

	def houston_get_img(msg,user,screen)
		Bot.log.info "#{__method__}: #{txt}"
		# TODO find the image associated to the user
		img = ""
		screen=self.find_by_name("houston/ask_saved",self.get_locale(user))
		screen[:text]=screen[:text] % {:img=>img}
		return self.get_screen(screen,user,msg)
	end


	def houston_save_email_cb(msg,user,screen)
		email=user.state['buffer']
		Bot.log.info "#{__method__}: #{email}"
		if email.match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/).nil? then
			screen=self.find_by_name("houston/email_wrong",self.get_locale(user))
			screen[:text]=screen[:text] % {:email=>email}
			return self.get_screen(screen,user,msg) 
		end
		screen=self.find_by_name("houston/email_saved",self.get_locale(user))
		screen[:text]=screen[:text] % {:email=>email}
		return self.get_screen(screen,user,msg)
	end

end

include Houston
