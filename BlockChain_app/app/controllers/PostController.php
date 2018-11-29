<?php

namespace app\controllers;

use Yii;
use yii\web\Controller;
use app\models\Posts;
use app\models\Users;



class PostController extends Controller
{

    /**
     * Displays homepage.
     *
     * @return string
     */

    public function actionIndex()
    {
        if (Yii::$app->user->isGuest) {
            return $this->redirect(['user/login']);
        }
        $model = new Posts();
        $posts = Posts::find()->orderBy(['created_at' => SORT_DESC])->all();
        return $this->render('index', ['posts' => $posts, 'model' => $model]);
    }

    public function actionAdd() {
        if (Yii::$app->user->isGuest) {
            return $this->redirect(['user/login']);
        }
        $model = new Posts();
        if ($model->load(Yii::$app->request->post())) {
            $user_id = Yii::$app->user->identity->user_id;

            $user = Users::findIdentity($user_id);
            if (!isset($user)) {
                throw new \Exception("This user(user_id: {$user_id}) is not proper.");
            }
            $model->user_id = $user_id;

            if ($model->save()) {
                Yii::$app->session->setFlash('postSubmitted');
                return $this->redirect(['index']);
           }
       }
        return $this->redirect(['index']);
    }
/*
   public function actionPost() {
        if (Yii::$app->user->isGuest) {
            return $this->redirect(['user/login']);
        }
        $user_id = Yii::$app->user->identity->user_id;
        $model = Users::findIdentity($user_id);
        if (!isset($model)) {
            throw new \Exception("This user(user_id: {$user_id}) is not proper.");
        }

        $addressFlg = ($model->personaladdress) ? true : false;

        if ($model->load(Yii::$app->request->post())) {

            // save address and give 100 token
            if (!$addressFlg && $model->personaladdress) {
                $nodeJsPath = Yii::getAlias('@webroot') . '/../scripts/send_token.js';
                $ret = exec("cd ". dirname($nodeJsPath). " && node send_token.js ". $model->personaladdress ." 2>&1", $out, $err);
                if ($err != 0 || (count($out) == 2 && !preg_match("/^0x[0-9a-f]{64}$/", $out[1]))) {
                    Yii::$app->session->setFlash('userFormSubmittedError');
                    return $this->refresh();
                }
            }

            if ($model->save()) {
                Yii::$app->session->setFlash('userFormSubmitted');
                return $this->refresh();
            }
        }
        return $this->render('post', [
            'model' => $model,
        ]);
    }
*/
}
