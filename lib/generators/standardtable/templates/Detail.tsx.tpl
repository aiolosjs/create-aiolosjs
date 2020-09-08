import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'umi';
import { Card, Descriptions } from 'antd';

import { IRootState } from './interface';
import { <%= firstUpperCaseProjectName%>DataProps } from './model';

export interface DetailProps {
  currentItem: Partial<<%= firstUpperCaseProjectName%>DataProps>;
}

const DetailInfo: React.FC<DetailProps> = ({ currentItem }) => {
  const dispatch = useDispatch();
  const { <%= lowerCaseProjectName%>, loading } = useSelector((state: IRootState) => state);
  const { detailInfo = {} } = <%= lowerCaseProjectName%>;
  const dataLoading = loading.effects['<%= lowerCaseProjectName%>/fetchDetailInfo'];

  useEffect(() => {
    const { id } = currentItem;
    dispatch({
      type: '<%= lowerCaseProjectName%>/fetchDetailInfo',
      payload: { id },
    });
  }, []);

  const { name, sex } = detailInfo;

  return (
    <div>
      <Card loading={dataLoading}>
        <Descriptions>
          <Descriptions.Item label="姓名">{name}</Descriptions.Item>
          <Descriptions.Item label="性别">{sex}</Descriptions.Item>
        </Descriptions>
      </Card>
    </div>
  );
};

export default DetailInfo;
