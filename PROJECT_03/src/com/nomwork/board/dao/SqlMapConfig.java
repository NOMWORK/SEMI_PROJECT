package com.nomwork.board.dao;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class SqlMapConfig {

	private SqlSessionFactory sqlSessionFactory;

	public SqlSessionFactory getSqlSessionFactory() {
	
		String resouce = "com/db/config.xml";
		
		try {
			Reader reader = Resources.getResourceAsReader(resouce);
			
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
			
			reader.close();
		}catch(IOException e) {
			
		}
		return sqlSessionFactory;
	}
}
