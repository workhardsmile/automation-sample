module Helper
  module IronHideDbUtil
    class << self
      def expect_db_fields?(sql_str,expected_hash={'field' => ''})
        flag = true
        if sql_str
          db_row = DatabaseMysql.new($env).query(sql_str)[0] rescue {}
          flag = (db_row.merge(expected_hash)==db_row)
          Common.logger_info("get: #{db_row}\nexpect: #{expected_hash}") unless flag
        end
        flag
      end

      def delete_feature_by_title(title)
        sql = "delete from  feature_anchor_relations where feature_anchor_id in (select A.id from feature_anchors A inner join features B on A.feature_id=B.id where B.title='#{title}')"
        DatabaseMysql.new($env).query(sql)
        sql = "delete from feature_anchors where feature_id in (select id from features where title='#{title}')"
        DatabaseMysql.new($env).query(sql)
        sql = "delete from features where title='#{title}'"
        DatabaseMysql.new($env).query(sql)
      end

      def delete_actile_by_title(title)
        # sql = "delete from  article_comment_votes where article_comment_id in (select A.id from comments A inner join articles B on A.item_id=B.id where A.item_type=1 and B.title='#{title}')"
        # DatabaseMysql.new($env).query(sql)
        sql = "delete from comments where item_type=1 and item_id in (select id from articles where title='#{title}')"
        DatabaseMysql.new($env).query(sql)
        sql = "delete from attachments where item_type=1 and item_id in (select id from articles where title='#{title}')"
        DatabaseMysql.new($env).query(sql)
        sql = "delete from articles where title='#{title}'"
        DatabaseMysql.new($env).query(sql)
      end

      def get_anchor_id_by_anchor_name_and_title(anchor_name,title)
        sql = "select A.id from feature_anchors A inner join features B on A.feature_id=B.id where B.title='#{title}' and A.name='#{anchor_name}'"
        anchor_id = DatabaseMysql.new($env).query(sql)[0]['id'] rescue nil
      end

      def get_max_feature_id_by_title(title=nil)
        sql = "select max(id) id from features"
        sql = "#{sql} where title='#{title}'" unless title.nil?
        feature_id = DatabaseMysql.new($env).query(sql)[0]['id'] rescue nil
      end

      def get_one_feature_title
        sql = "select * from features limit 1"
        title = DatabaseMysql.new($env).query(sql)[0]['title'] rescue nil
      end

      def get_one_notification_id_by_mobile(mobile)
        sql = "select max(A.id) id from notifications A inner join users B on A.to_user_id=B.id where B.mobile='#{mobile}'"
        notification_id = DatabaseMysql.new($env).query(sql)[0]['id'] rescue nil
      end

      def update_user_mobile(old_mobile,new_mobile)
        sql_str = "UPDATE users SET mobile='#{new_mobile}' WHERE mobile='#{old_mobile}'"
        DatabaseMysql.new($env).query(sql_str)
      end

      def update_user_name(old_name,new_name)
        sql_str = "UPDATE users SET user_name='#{new_name}' WHERE user_name='#{old_name}'"
        DatabaseMysql.new($env).query(sql_str)
      end

      def get_userid_by_mobile(mobile)
        userid = DatabaseMysql.new($env).query("select id user_id from users where mobile='#{mobile}'")[0]['user_id']
      end

      def get_user_row_by_mobile(mobile)
        result = DatabaseMysql.new($env).query("select * from users where mobile='#{mobile}' limit 1")[0] rescue nil
      end

      def get_user_row_unless_mobile(mobile)
        result = DatabaseMysql.new($env).query("select * from users where mobile!='#{mobile}' limit 1")[0] rescue nil
      end

      def get_one_valid_feature_id(userid=nil)
        sql = "select max(id) id from features where start_time<=utc_timestamp() and end_time>=utc_timestamp()"
        sql = "#{sql} and user_id=#{userid}" unless userid.nil?
        feature_id = DatabaseMysql.new($env).query(sql)[0]['id'] rescue nil
      end

      def get_one_valid_comment_id
        comment_id = DatabaseMysql.new($env).query("select max(id) comment_id from comments")[0]['comment_id']
      end

      def get_one_valid_comment_id_by_userid(userid)
        comment_id = DatabaseMysql.new($env).query("select min(id) comment_id from comments where user_id=#{userid}")[0]['comment_id'] rescue nil
      end

      def get_one_valid_comment_id_unless_userid(userid)
        comment_id = DatabaseMysql.new($env).query("select min(id) comment_id from comments where user_id!=#{userid}")[0]['comment_id'] rescue nil
      end

      def get_one_valid_comment_id_by_mobile(mobile, article_id=nil)
        sql = "select min(id) comment_id from comments where user_id in (select id user_id from users where mobile='#{mobile}')"
        sql = "#{sql} and item_type=1 and item_id=#{article_id}" unless article_id.nil?
        comment_id = DatabaseMysql.new($env).query(sql)[0]['comment_id'] rescue nil
      end

      def get_one_valid_comment_id_unless_mobile(mobile, article_id=nil)
        sql = "select min(id) comment_id from comments where user_id not in (select id user_id from users where mobile='#{mobile}')"
        sql = "#{sql} and item_type=1 and item_id=#{article_id}" unless article_id.nil?
        comment_id = DatabaseMysql.new($env).query(sql)[0]['comment_id'] rescue nil
      end

      def get_one_valid_comment_id_unless_mobile_unless_article(mobile, article_id)
        sql = "select min(id) comment_id from comments where user_id not in (select id user_id from users where mobile='#{mobile}')"
        sql = "#{sql} and item_type=1 and item_id!=#{article_id}"
        comment_id = DatabaseMysql.new($env).query(sql)[0]['comment_id'] rescue nil
      end

      def get_one_valid_article_id
        article_id = DatabaseMysql.new($env).query("select max(id) article_id from articles")[0]['article_id']
      end

      def get_one_valid_article_id_by_userid(userid)
        article_id = DatabaseMysql.new($env).query("select max(id) article_id from articles where user_id=#{userid}")[0]['article_id'] rescue nil
      end

      def get_one_valid_article_id_by_mobile(mobile)
        article_id = DatabaseMysql.new($env).query("select min(id) article_id from articles where user_id in (select id user_id from users where mobile='#{mobile}')")[0]['article_id'] rescue nil
      end

      def get_one_valid_article_id_unless_mobile(mobile)
        article_id = DatabaseMysql.new($env).query("select min(id) article_id from articles where user_id not in (select id user_id from users where mobile='#{mobile}')")[0]['article_id'] rescue nil
      end

      def get_sms_code(type, mobile, password=nil, api_path = '/api/mobile/v1/users/sms')
        redis = DatabaseRedis.new($env)
        api_base = ApiCallBase.new
        if type == 1 || type.to_s.downcase == 'register'
          params = {'type' => 1, 'mobile' => mobile}
          response = api_base.post_by_api(api_path,params)
          Common.logger_info response
          sleep(1)
        code = redis.get_register_code_by_mobile(mobile)
        elsif type == 2 || type.to_s.downcase == 'forget'
          params = {'type' => 2, 'mobile' => mobile}
          response = api_base.post_by_api(api_path,params)
          Common.logger_info response
          sleep(1)
        code = redis.get_forget_code_by_mobile(mobile)
        elsif type == 3 || type.to_s.downcase == 'update'
          params = {'type' => 3, 'mobile' => mobile}
          api_base.set_user_token(mobile, password)
          response = api_base.post_by_api(api_path,params)
          Common.logger_info response
          sleep(1)
        code = redis.get_update_code_by_mobile(mobile)
        end
      end

      def reset_sms_by_mobile(mobile)
        DatabaseRedis.new($env).reset_sms_by_mobile(mobile)
      end
    end
  end
end