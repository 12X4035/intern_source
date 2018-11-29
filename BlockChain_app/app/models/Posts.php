<?php

namespace app\models;

use Yii;
use yii\db\ActiveRecord;
use yii\db\Expression;
use app\models\Users;

class Posts extends ActiveRecord
{
    public static function tableName() {
        return 'posts';
    }
/*
    public function rules()
    {
        return [
            [['post_id', 'content', 'user_id', 'created_at', 'updated_at'], 'safe']
	];
    }
*/
public function rules()
    {
        return [
            ['personaladdress', 'trim'],
            ['personaladdress', 'string', 'min' => 40],
            ['personaladdress', 'string', 'max' => 40],
            ['personaladdress', 'match', 'pattern' => '/^(0x)?[0-9a-f]{40}$/i'],
            ['nickname', 'string', 'min' => 3],
            ['nickname', 'string', 'max' => 40], 
            [['post_id', 'content', 'user_id', 'created_at', 'updated_at'], 'safe'],
            ['pooladdress', 'trim'],
            ['pooladdress', 'string', 'min' => 40],
            ['pooladdress', 'string', 'max' => 40],
            ['pooladdress', 'match', 'pattern' => '/^(0x)?[0-9a-f]{40}$/i']
        ];
    }

    public function beforeSave($insert)
    {
        $current_date = 'now()';
        if ($insert) {
            $this->setAttribute('created_at', new Expression($current_date));
        }
        if ($this->hasAttribute('updated_at') && !empty($this->dirtyAttributes)) {
            $this->setAttribute('updated_at', new Expression($current_date));
        }
        return parent::beforeSave($insert);
    }

    public function getUser()
    {
        return $this->hasOne(Users::className(), ['user_id' => 'user_id']);
    }
}
