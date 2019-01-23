package com.nomwork.mybatis;

import java.io.IOException;
import java.io.Reader;
import java.util.Properties;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class SqlMapConfig {

	public SqlSessionFactory sqlSessionFactory;
	
	public SqlSessionFactory getSqlSessionFactory() {
		
		String resource = "com/nomwork/mybatis/config.xml";       //이 주소로 sqlSettionFactory를 만든다.

		try {
			Reader reader = Resources.getResourceAsReader(resource);         //아래를 만들기 위해서 Reader 사용
			
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader); //위 주소로 sqlSettionFactory를 만들어진다.
			
			reader.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return sqlSessionFactory;
	}
	
	
}
