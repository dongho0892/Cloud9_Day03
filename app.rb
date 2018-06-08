require 'sinatra'
require 'sinatra/reloader'
require 'rest-client'
require 'uri'
require 'nokogiri'

get '/' do
    erb :app
end


get '/calculate' do

    num1 = params[:n1].to_i      # n1 라는 친구를 받아주고
    num2 = params[:n2].to_i      # n2 라는 친구를 받아준다.
    
    @sum = num1 + num2
    @min = num1 - num2
    @mul = num1 * num2
    @div = num1 / num2
    
    erb :calculate # 참고할 파일 이름은 비슷하게 할 것
            # 넘어가는 자료들은 String 타입으로 오가기 떄문에 .to_i 를 붙여주어야함.
end



get '/numbers' do

    erb :numbers
    
    # numbers
end


#  Html form => W3C school Form 내용
#  <form action="/action_page.php">

##############################################################################

get '/form' do
    erb :form
end


id = "multi"    # id 1개만 만들어보기  
pw = "campus"   # 일때만 로그인이 되도록

post '/login' do
    
    # 아이디가 같니?
    if id.eql?(params[:id])
        
        # 비밀번호 체크 - 로직구성
        if pw.eql?(params[:password])
            redirect '/complete'
            
        else # 비밀번호 틀렸을 경우
            @msg ="비밀번호가 틀립니다."
            redirect '/error?err_co=2'
            
        end
    else
        # 아이디가 존재하지 않습니다.  - 로직 구성
        @msg ="ID가 존재하지 않습니다."
        redirect '/error?err_co=1'
    end
end


# 계정이 존재 하지 않거나, 비밀번호가 틀린 경우

get '/error' do
    # 서로 다른 뱡식으로 에러메시지를 보여줘야함.
    
    if params[:err_co].to_i == 1
    # ID 문제
            @msg = "에러코드 1"
    elsif params[:err_co].to_i == 2
    # password 문제
            @msg = "에러코드 2"
    else
        @msg = "에러코드 non"

    end
    # 상태코드 http status code
    erb :error
end

# 로그인 완료 된 곳
get '/complete' do
    erb :complete
end

###########################################


get '/search'do
    erb :search
end

get '/naversearch' do
    redirect "https://search.naver.com/search.naver?query=#{params[:naver]}"
end

get '/googlesearch' do
    redirect "https://www.google.com/search?q=#{params[:google]}"
end

post '/naversearch' do
    url = URI.encode("https://search.naver.com/search.naver?query=#{params[:naver]}")
    redirect url
end

post '/googlesearch' do
    url = URI.encode("https://www.google.com/search?q=#{params[:google]}")
    redirect url
end

########################################################################

# op-gg 만들기

# 1. op.gg 에서 직접 검색한 결과
# 2. 승 패 수만 보여주기
# 3. select 태그를 이용해서 2가지 방법 중 선택하기
#    ( 밑으로 내려서 열 수 있는 것 하나 ) 

# 조건 :  form 태그는 하나 / action= 1개만

get '/op_gg' do
    if params[:character]
        case params[:search_method]
            # op.gg 에서 승/패 수 만 크롤링 하여 보여줌
        when "self"
            # RestClient를 통해 op.gg에서 검색결과 페이지를 크롤링한다.
                # (httparty 와 비슷하게 생김)
            
            
            url = RestClient.get(URI.encode("http://www.op.gg/summoner/userName=#{params[:character]}"))
            
            # 검색결과 페이지 중에서 win과 lose 부분을 찾음
            result = Nokogiri::HTML.parse(url)
            # nokogiri를 이용하여 원하는 부분을 골라냄.
            # #GameAverageStatsBox-summary > div.Box > table > tbody > tr:nth-child(1) > td:nth-child(1) > div > span.win #
            win = result.css('span.win').first
            lose = result.css('span.lose').first
            # 검색결과를 페이지에서 보여주기 위한 변수 선언 
            @win = win.text         # controller 에서 view 까지
            @lose = lose.text

            # 검색 결과를 op.gg에서 보여줌.
            erb:opgg   # 넘겨줌.
            
        when "opgg"
            url = URI.encode("http://www.op.gg/summoner/userName=#{params[:character]}")
            redirect url
        end
    end
end

get '/opgg' do
    erb :opgg
end





# get '/gg' do
#   if params[:self]
#       redirect "http://www.op.gg/summoner/userName=#{params[:character]}"
      
#   end
#   erb:opgg
    
# end



get '/url/wild'do
    erb :url/wild
end

